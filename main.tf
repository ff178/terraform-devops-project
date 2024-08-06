module "vpc" {
  source = "./module"

  vpc_name              = "my-vpc"
  vpc_cidr              = "10.0.0.0/16"
  public_subnets_cidr   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  public_subnets_count  = 3
  private_subnets_count = 3
  nat_gateways_count    = 3
}

