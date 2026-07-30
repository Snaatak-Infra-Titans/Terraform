variable "aws_region" {
  description = "AWS Region"
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
  description = "Resource owner"
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

variable "database_subnet_name" {
  description = "Name tag of the existing database subnet"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 Key Pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_owner_id" {
  description = "AWS Account ID of the AMI owner"
  type        = string
}

variable "ami_name" {
  description = "AMI name"
  type        = string
}

variable "ssm_instance_profile" {
  description = "IAM Instance Profile attached to the EC2 instance"
  type        = string
}

variable "scylla_port" {
  description = "Port used by ScyllaDB CQL"
  type        = number
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
}

variable "root_volume_encrypted" {
  description = "Enable encryption for the root EBS volume"
  type        = bool
}
