# Define a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Define a internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Define 3 publics subnets with count and set cidr_blocks for each 
resource "aws_subnet" "public" {
  count = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Define 3 private subnets with count and set cidr_blocks for each 
resource "aws_subnet" "private" {
  count = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index + 4)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Define a route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

#Attach public subnets with the route table
resource "aws_route_table_association" "public" {
  count = 3
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#Define 3 NAT Gateways
resource "aws_eip" "nat" {
  count = 3

  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count = 3
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "main-ngw-${count.index + 1}"
  }
}

#Define a route table for each NAT Gateway
resource "aws_route_table" "private" {
  count = 3
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "private-route-table-${count.index + 1}"
  }
}

#Attach each NAT Gateway route table with each private subnet
resource "aws_route_table_association" "private" {
  count = 3
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}