output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_id" {
  description = "IDs of the private subnet"
  value       = aws_subnet.subnet-public[*].id
}

output "public_subnet_id" {
  description = "IDs of the public subnet"
  value       = aws_subnet.subnet_private[*].id
}
