variable "env" {
    description = "deployment environment"
    type        = string
}

variable "cidr" {
    description = "CIDR blocks"
    type        = list(string)
    default     = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "az" {
    description = "Availability zones"
    type        = list(string)
    default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
