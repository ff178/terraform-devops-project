variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_count" {
  description = "The number of public subnets"
  type        = number
  default     = 3
}

variable "public_subnets_cidr" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_count" {
  description = "The number of private subnets"
  type        = number
  default     = 3
}

variable "private_subnets_cidr" {
  description = "A list of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "nat_gateways_count" {
  description = "The number of NAT Gateways"
  type        = number
  default     = 3
}
