#Define variables

variable "region" {
    type = string
    default = "us-east-2"
}

variable "vpc_name" {
  type = string
  default = "devops"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "key_name" {
    type = string
    default = "ff"
}

variable "key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHiEjmjUluSBKtGaGRmT+nsPtPZtjhYH5V5ZGtWbf2CZUeInSXk1/I195pnKKCOP8eZmFBw4daS0Cp+FSbMlbVRS3XiKYpX40h8degfOkBEQYSzmQwo1we3h4jaYffGskiXeqPejqBI9ia9qQnT3BVda4yeRl6ziG4kwUJas/5ROCH4CCcIk9C2FrW2NmpEV6fQgWMxMKFO0ogPZsp5xaVF5qcUMHE09Ce3Ujli6F5VP8yv/ixS2TZPOejC3RsY4jH4pVNbNldZJVUVasrOG9ZV8iUZW+WGkFc5eFBkwd8amh4U1sBCRqLVlJ/CvhBcoB6wobpYc+U4Z8QhPzm2ydxfuWWkw95dphXGTPU/vRXuXYdn2W6WRHVPoBQZzbpVkjifAEuLw1/D/MdNQP7jj4GhADdVIK9SHx0NmigutXF6trAr5pvde5TVWi2IGzG7qw6CitqMt4wujACU1Qn2JjzOYjoVr8ruxnHp/KFB0urg/q9vFfZ/MbYCfGmBtltZ/k= 12245@LAPTOP-RBFMU6TJ"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "hosted_zone_id" {
  type = string
  default = "Z1234567890"
}

variable "domain_name" {
  type = string
  default = "yourdomain.com"
}

variable "db_name" {
  type = string
  default = "db_wordpress"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "db_password" {
  type = string
  default = "admin"
}

variable "db_instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "db_engine" {
  type = string
  default = "mysql"
}

variable "db_engine_version" {
  type = string
  default = "8.0"
}