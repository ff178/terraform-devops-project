output "vpc_id" {
  value = module.project.vpc_id
}

output "public_subnets" {
  value = module.project.public_subnets
}

output "private_subnets" {
  value = module.project.private_subnets
}

output "nat_gateway_ids" {
  value = module.project.nat_gateway_ids
}

output "alb_dns_name" {
  value = module.project.alb_dns_name
}

output "asg_name" {
  value = module.project.asg_name
}

output "db_endpoint" {
  value = module.project.db_endpoint
}

output "db_name" {
  value = module.project.db_name
}

output "rds_cluster_id" {
  value = module.project.rds_cluster_id
}

output "rds_writer_instance_id" {
  value = module.project.rds_writer_instance_id
}

output "rds_reader_instance_ids" {
  value = module.project.rds_reader_instance_ids
}