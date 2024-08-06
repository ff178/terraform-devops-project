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
