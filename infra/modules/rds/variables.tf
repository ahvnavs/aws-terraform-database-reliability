variable "env" {
    description = "deployment environment"
    type        = string
}

variable "private_subnet_ids" {
    description = "subnet id"
    type = list(string)
}

variable "rds_sg_id" {
    description = "rds sg id"
    type = string
}

variable "db_instance_class" {
    description = "instance of db"
    type = string
}

variable "backup_retention_period" {
    description = "backup period"
    type = number
}

variable "deletion_protection" {
    description = "protection"
    type = bool
}

variable "db_password" {
    description = "password for db"
    type = string
    sensitive = true
}

variable "db_username" {
    description = "usernamw for db"
    type = string
    sensitive = true
}
