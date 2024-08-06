# Output vpc id
output "vpc_id" {
    value = aws_vpc.main.id
}

# Output vpc cidr
output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}

# Output  public subnets ids
output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}

# Output  private subnets ids
output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}

# # output "instance_ids" {
# #     value = aws_instance.example[*].id
# # }
