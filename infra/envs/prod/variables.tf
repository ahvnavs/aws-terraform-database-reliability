variable "aws_region" {
  description = "region"
  type        = string
}

variable "env" {
  description = "env"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr block"
  type        = list(string)
}

variable "db_username" {
  description = "user"
  type        = string
}

variable "db_password" {
  description = "pass"
  type        = string
}

variable "db_instance_class" {
  description = "instance of db"
  type        = string
}

variable "backup_retention_period" {
  default = "retention"
  type    = number
}

variable "deletion_protection" {
  description = "protect"
  type        = bool
}
