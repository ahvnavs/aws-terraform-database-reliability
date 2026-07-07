variable "env" {
    description = "deployment environment"
    type        = string
}

variable "vpc_id" {
    description= "vpc id"
    type = string
}

variable "public_subnet_ids" {
    description = "pub sub id"
    type = list(string)
}

variable "private_subnet_ids" {
    description = "pri sub id"
    type = list(string)
}

variable "alb_sg_id" {
    description = "alb security group"
    type = string
}

variable "ecs_sg_id" {
    description = "ecs security group"
    type = string
}
