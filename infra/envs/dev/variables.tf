variable "aws_region" { type = string }
variable "env" { type = string }
variable "vpc_cidr" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_instance_class" { type = string }
variable "backup_retention_period" { type = number }
variable "deletion_protection" { type = bool }
