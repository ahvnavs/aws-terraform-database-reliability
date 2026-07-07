output "alb_sg_id" {
    description = "ALB"
    value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
    description = "ECS"
    value       = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
    description = "RDS"
    value       = aws_security_group.rds_sg.id
}
