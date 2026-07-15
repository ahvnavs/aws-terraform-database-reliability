output "alb_sg_id" {
  description = "ALB SG ID"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "ECS SG ID"
  value       = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
  description = "RDS SG ID"
  value       = aws_security_group.rds_sg.id
}
