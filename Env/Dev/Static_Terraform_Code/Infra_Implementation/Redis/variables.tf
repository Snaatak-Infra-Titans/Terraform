variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "application" {
  type = string
}

variable "owner" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "database_subnet_name" {
  type = string
}

variable "ssm_instance_profile" {
  type        = string
  description = "Name of the manually created IAM Instance Profile for SSM"
}
