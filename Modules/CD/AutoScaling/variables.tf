variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "application" {
  description = "Application or service name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Auto Scaling instances"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for Auto Scaling instances"
  type        = string
}

variable "application_port" {
  description = "Application port"
  type        = number
}

variable "listener_arn" {
  description = "Existing HTTPS ALB listener ARN"
  type        = string
}

variable "listener_rule_priority" {
  description = "ALB listener rule priority"
  type        = number
}

variable "listener_rule_paths" {
  description = "ALB listener rule path patterns"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID used by the Launch Template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile for EC2 instances"
  type        = string
}
