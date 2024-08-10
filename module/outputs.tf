output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private.*.id
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateways"
  value       = aws_nat_gateway.nat.*.id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.wordpress_alb.dns_name
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.wordpress_asg.name
}

output "db_endpoint" {
  description = "The endpoint of the RDS database"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "db_name" {
  description = "The name of the RDS database"
  value       = var.db_name
}


output "rds_cluster_id" {
  description = "The RDS cluster identifier."
  value       = aws_rds_cluster.rds_cluster.id
}

output "rds_writer_instance_id" {
  description = "The writer RDS instance identifier."
  value       = aws_rds_cluster_instance.writer.id
}

output "rds_reader_instance_ids" {
  description = "The list of reader RDS instance identifiers."
  value       = aws_rds_cluster_instance.readers[*].id
}
