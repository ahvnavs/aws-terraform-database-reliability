output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "public subnet ids"
  value       = [aws_subnet.pub_sub01.id, aws_subnet.pub_sub02.id]
}

output "private_subnet_ids" {
  description = "private subnet ids"
  value       = [aws_subnet.pri_sub01.id, aws_subnet.pri_sub02.id]
}
