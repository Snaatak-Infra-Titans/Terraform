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
  type        = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_owner_id" {
  type        = string
  description = "AWS Account ID of the AMI owner"
}

variable "ami_name" {
  type        = string
  description = "AMI name"
}
