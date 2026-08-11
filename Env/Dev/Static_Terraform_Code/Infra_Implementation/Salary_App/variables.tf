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

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_owner_id" {
  type        = string
  description = "AWS Account ID of the custom AMI owner"
}

variable "ami_name" {
  type        = string
  description = "Name of the golden AMI for the Salary application"
}

variable "ssm_instance_profile" {
  type        = string
  description = "Name of the IAM Instance Profile for EC2 SSM access"
}
