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

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
  default     = "ami-0c11a84584d4e09dd"
}

variable "instance_type" {
  description = "The instance type to use for the instances"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "SSH key name to use for EC2 instances"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone where DNS records will be created"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the WordPress application"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "wordpress_db"
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance type of the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "8.0"
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "wordpress-db-subnet-group"
}


variable "environment_variables" {
  description = "Environment variables to pass to the WordPress application"
  type        = map(string)
  default     = {
    DB_NAME = "wordpress_db"
    DB_USER = "admin"
    DB_PASSWORD = "password"
    DB_HOST = "db.example.com"
  }
}



variable "cluster_identifier" {
  description = "The identifier for the RDS cluster."
  type        = string
}

variable "engine_cluster" {
  description = "The name of the database engine to be used for this RDS cluster."
  type        = string
}

variable "engine_version_cluster" {
  description = "The version number of the database engine to use."
  type        = string
}

variable "database_name_cluster" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
}

variable "master_username_cluster" {
  description = "The master username for the database."
  type        = string
}

variable "master_password_cluster" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "The number of days to retain backups."
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created."
  type        = string
  default     = "07:00-09:00"
}


variable "db_subnet_group_name_cluster" {
  description = "The name of the DB subnet group to use for the RDS cluster."
  type        = string
}

variable "instance_class_cluster" {
  description = "The instance class to use for the RDS instances."
  type        = string
}

variable "apply_immediately" {
  description = "Whether any cluster modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

# variable "availability_zones" {
#   description = "A list of EC2 Availability Zones that instances in the DB cluster can be created in."
#   type        = list(string)
#   default     = []
# }

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Boolean indicating whether the DB instance is publicly accessible."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}


