variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "owner" {
  description = "Name of the owner"
  type        = string
}

variable "cost_center" {
  description = "Name of the owner"
  type        = string
}

variable "application" {
  description = "Name of the owner"
  type        = string
}
