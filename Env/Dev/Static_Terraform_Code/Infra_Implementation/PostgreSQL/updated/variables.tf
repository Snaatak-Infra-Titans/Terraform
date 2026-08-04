variable "aws_region" {
  description = "AWS region where resources will be deployed."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "application" {
  description = "Application name."
  type        = string
}

variable "owner" {
  description = "Team responsible for managing the resource."
  type        = string
}

variable "cost_center" {
  description = "Cost center used for resource tagging."
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing Dev VPC."
  type        = string
}

variable "database_subnet_id" {
  description = "ID of the existing private database subnet."
  type        = string
}

variable "postgresql_allowed_cidr" {
  description = "CIDR allowed to connect to PostgreSQL on port 5432."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for PostgreSQL."
  type        = string
}

variable "ssm_instance_profile_name" {
  description = "Name of the existing IAM instance profile used for SSM access."
  type        = string
}

variable "ami_owner_id" {
  description = "AWS account ID of the AMI owner."
  type        = string
}

variable "ami_name" {
  description = "Ubuntu AMI name pattern."
  type        = string
}

variable "root_volume_size" {
  description = "EC2 root volume size in GiB."
  type        = number
  default     = 15
}

variable "root_volume_type" {
  description = "EC2 root EBS volume type."
  type        = string
  default     = "gp3"
}
