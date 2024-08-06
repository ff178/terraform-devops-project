module "project" {
  source = "./module"

  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  public_subnets_count  = 3
  private_subnets_count = 3
  nat_gateways_count    = 3
  ami_id                = data.aws_ami.amazon_linux.id
  instance_type         = var.instance_type
  ssh_key_name          = var.key_name
  hosted_zone_id        = var.hosted_zone_id
  domain_name           = var.domain_name
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = 20
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
}
