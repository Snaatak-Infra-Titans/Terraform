variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for ASG instances"
  type        = string
}

variable "application_port" {
  description = "Application port"
  type        = number
}

variable "ami_id" {
  description = "AMI ID for Launch Template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}
