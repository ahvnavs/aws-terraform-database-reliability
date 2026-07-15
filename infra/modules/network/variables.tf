variable "env" {
  description = "The deployment environment"
  type        = string
}

variable "cidr" {
  description = "CIDR blocks for VPC and Subnets"
  type        = list(string)
}

variable "az" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}
