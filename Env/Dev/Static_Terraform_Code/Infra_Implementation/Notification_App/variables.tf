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

variable "ami_owner_id" {
  type        = string
  description = "AWS Account ID of the Custom AMI owner"
}

variable "ami_id" {
  description = "AMI ID for Notification EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  type = string
}
