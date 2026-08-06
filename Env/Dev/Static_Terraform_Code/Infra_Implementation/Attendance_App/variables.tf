variable "aws_region" {
  description = "AWS region where Attendance API resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment such as dev, stage, or prod"
  type        = string
}

variable "application" {
  description = "Application name used for naming resources"
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
}

variable "ami_id" {
  description = "Attendance API AMI ID generated using Packer"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]+$", var.ami_id))
    error_message = "ami_id must be a valid AWS AMI ID starting with ami-."
  }
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the Attendance API"
  type        = string
  default     = "t3.small"
}

variable "ssm_instance_profile" {
  description = "Name of the existing IAM instance profile used for SSM access"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "cpu_target_value" {
  description = "Target average CPU utilization for Auto Scaling"
  type        = number
  default     = 70

  validation {
    condition     = var.cpu_target_value > 0 && var.cpu_target_value <= 100
    error_message = "cpu_target_value must be between 1 and 100."
  }
}

variable "common_tags" {
  description = "Standard tags applied to Attendance API resources"
  type        = map(string)
}
