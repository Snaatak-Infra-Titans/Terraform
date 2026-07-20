variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
}

variable "owner" {
  description = "Name of the owner"
  type        = string
}

variable "cost_center" {
  description = "Cost center"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID. Use this if you want exact lookup instead of tag lookup"
  type        = string
  default     = ""
}

variable "subnet_newbits" {
  description = "Extra bits added to VPC CIDR for subnet sizing"
  type        = number
  default     = 3
}

variable "az_suffix" {
  description = "Availability zone suffix like a, b, c"
  type        = string
  default     = "a"
}
