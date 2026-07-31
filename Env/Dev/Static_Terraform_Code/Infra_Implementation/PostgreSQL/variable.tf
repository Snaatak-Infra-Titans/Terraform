variable "aws_region" {
  description = "AWS region where the infrastructure resources will be deployed."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, qa, staging, prod)."
  type        = string
}

variable "application" {
  description = "Name of the application for which the infrastructure is being provisioned."
  type        = string
}

variable "owner" {
  description = "Owner or team responsible for managing the infrastructure resources."
  type        = string
}

variable "cost_center" {
  description = "Cost center used for resource tagging and cost allocation."
  type        = string
}

variable "vpc_name" {
  description = "Name of the existing Virtual Private Cloud (VPC)."
  type        = string
}

variable "database_subnet_name" {
  description = "Name tag of the database subnet where the instance will be deployed."
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair used for SSH access."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to launch (e.g., t3.micro, t3.small)."
  type        = string
}

variable "ami_owner_id" {
  description = "AWS Account ID of the AMI owner."
  type        = string
}

variable "ami_name" {
  description = "Name of the Amazon Machine Image (AMI) to be used for the EC2 instance."
  type        = string
}
