resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }
}


resource "aws_subnet" "private" {
  count      = var.private_subnets_count
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnets_cidr, count.index)

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = var.nat_gateways_count

  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count          = var.nat_gateways_count
  allocation_id  = aws_eip.nat[count.index].id
  subnet_id      = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  count = var.private_subnets_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name = "${var.vpc_name}-private-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnets_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

#Security Groups

# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTP traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTPS traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows all outbound traffic
  }

  tags = {
    Name = "${var.vpc_name}-alb-sg"
  }
}

# Security Group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Allow traffic from ALB
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTPS traffic from anywhere
    # security_groups = [aws_security_group.db_sg.id] # Allow traffic to DB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows all outbound traffic
  }

  tags = {
    Name = "${var.vpc_name}-ec2-sg"
  }
}

# Security Group for the Database
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for the database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # Allow traffic from EC2 instances
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows all outbound traffic
  }

  tags = {
    Name = "${var.vpc_name}-db-sg"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-ssh"
  }
}


#ASG--------ASG#
resource "aws_launch_template" "wordpress" {
  name_prefix   = "${var.vpc_name}-wordpress"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.public[0].id
    security_groups             = [aws_security_group.ec2_sg.id, aws_security_group.allow_ssh.id]
  }

  key_name      = var.ssh_key_name
 

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update package repository
    sudo yum update -y

    # Add the MySQL 5.7 repository
    sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

    #Import GPG KEY
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
    
    #Install MySQL server
    sudo yum install -y mysql-community-server

     # Install Apache, PHP, and related packages
    sudo yum install -y httpd php php-mysqlnd php-fpm

    # Start and enable Apache and MySQL services
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl start mysqld
    sudo systemctl enable mysqld

    #Set root password
    sudo systemctl stop mysqld
    sudo mysqld_safe --skip-grant-tables &
    mysql -u root
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${var.db_password}';
    FLUSH PRIVILEGES;
    EXIT;
    sudo killall mysqld_safe
    sudo systemctl start mysqld

    #Timeout for db start
    sleep 30

    # Create WordPress database and user
    DB_NAME="${var.db_name}"
    DB_USER="${var.db_username}"
    DB_PASSWORD="${var.db_password}"
    DB_HOST="${aws_db_instance.wordpress_db.endpoint}"

    sudo mysql -u root -p'${var.db_password}' -e "CREATE DATABASE ${var.db_name};"
    sudo mysql -u root -p'${var.db_password}' -e "CREATE USER '${var.db_username}'@'localhost' IDENTIFIED BY '${var.db_password}';"
    sudo mysql -u root -p'${var.db_password}' -e "GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_username}'@'localhost';"
    sudo mysql -u root -p'${var.db_password}' -e "FLUSH PRIVILEGES;"

    # Download and configure WordPress
    cd /var/www/html
    sudo wget https://wordpress.org/latest.tar.gz
    sudo tar -xzf latest.tar.gz
    sudo rm -f latest.tar.gz
    sudo cp wordpress/wp-config-sample.php wordpress/wp-config.php

    # Update wp-config.php with database details
    sudo sed -i "s/database_name_here/${var.db_name}/" wordpress/wp-config.php
    sudo sed -i "s/username_here/${var.db_username}/" wordpress/wp-config.php
    sudo sed -i "s/password_here/${var.db_password}/" wordpress/wp-config.php
    sudo sed -i "s/localhost/${aws_db_instance.wordpress_db.endpoint}/" wordpress/wp-config.php

    # Set appropriate permissions
    sudo chown -R apache:apache /var/www/html/wordpress
    sudo chmod -R 755 /var/www/html/wordpress

    # Configure Apache to serve WordPress
    sudo tee /etc/httpd/conf.d/wordpress.conf > /dev/null <<-CONFIG_EOF
    <VirtualHost *:80>
        DocumentRoot "/var/www/html/wordpress"
        <Directory "/var/www/html/wordpress">
            AllowOverride All
            Require all granted
        </Directory>
    </VirtualHost>
    CONFIG_EOF

    # Restart Apache to apply changes
    sudo systemctl restart httpd

    # Output the details for WordPress setup
    echo "WordPress has been installed!"
    echo "Database Name: ${var.db_name}"
    echo "Database User: ${var.db_username}"
    echo "Database Password: ${var.db_password}"
 
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.vpc_name}-wordpress-instance"
    }
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  vpc_zone_identifier = aws_subnet.public.*.id
  desired_capacity    = 1
  min_size            = 1
  max_size            = 99

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [aws_lb_target_group.wordpress_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-wordpress-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "wordpress_alb" {
  name               = "${var.vpc_name}-wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public[0].id,  # Subnet in AZ 1
    aws_subnet.public[1].id,  # Subnet in AZ 2
    aws_subnet.public[2].id   # Subnet in AZ 3
  ]
  
  enable_deletion_protection = false

  tags = {
    Name = "${var.vpc_name}-wordpress-alb"
  }
}

resource "aws_lb_target_group" "wordpress_tg" {
  name     = "${var.vpc_name}-wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.vpc_name}-wordpress-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_route53_record" "wordpress" {
  zone_id = var.hosted_zone_id
  name    = "wordpress.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.wordpress_alb.dns_name
    zone_id                = aws_lb.wordpress_alb.zone_id
    evaluate_target_health = true
  }
}

#DATABASE--------DATABASE#
resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  identifier              = "${var.vpc_name}-wordpress-db"
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  db_name                 = var.db_name  
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.wordpress_db_subnet_group.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  tags = {
    Name = "${var.vpc_name}-wordpress-db"
  }
}