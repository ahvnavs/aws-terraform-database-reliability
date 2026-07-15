variable "aws_region" {
    description = "AWS region"
    type        = string
}

variable "env" {
    description = "Environment name"
    type        = string
}

variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string
}

variable "db_username" {
    description = "Database username"
    type        = string
}

variable "db_password" {
    description = "Database password"
    type        = string
    sensitive   = true
}

variable "db_instance_class" {
    description = "RDS instance class"
    type        = string
}

variable "backup_retention_period" {
    description = "Number of days to retain backups"
    type        = number
}

variable "deletion_protection" {
    description = "Enable or disable deletion protection"
    type        = bool
}
