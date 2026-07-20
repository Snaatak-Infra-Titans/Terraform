variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "application" {
  description = "Application name"
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

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID. Use this if you want exact lookup"
  type        = string
  default     = ""
}

variable "subnet_newbits" {
  description = "Number of bits to add for subnetting"
  type        = number
  default     = 3
}

variable "azs" {
  description = "Availability zones suffixes to use"
  type        = list(string)
  default     = ["a", "b"]
}
