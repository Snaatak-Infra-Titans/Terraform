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

variable "key_name" {
  type        = string
  description = "Existing EC2 Key Pair name"
}

variable "ami_name" {
  type        = string
  description = "Name of the AMI used for Redis EC2"
}

variable "ami_owner_id" {
  type        = string
  description = "AWS Account ID that owns the AMI"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ssm_instance_profile" {
  type        = string
  description = "Name of the existing IAM Instance Profile for SSM"
}
