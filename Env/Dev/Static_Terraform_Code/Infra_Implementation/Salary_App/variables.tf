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

variable "ami_name" {
  type        = string
  description = "Name of the golden AMI for the Notification app"
}

variable "ami_owner_id" {
  type        = string
  description = "AWS Account ID of the Custom AMI owner"
}


variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ssm_instance_profile" {
  type        = string
  description = "Name of the manually created IAM Instance Profile for SSM"
}
