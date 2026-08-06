variable "application" {
  description = "Application name used in resource naming and tagging"
  type        = string

  validation {
    condition     = length(trimspace(var.application)) > 0
    error_message = "application must not be empty."
  }
}

variable "asg_desired_capacity" {
  description = "Desired number of Attendance API instances"
  type        = number
  default     = 1

  validation {
    condition     = var.asg_desired_capacity >= 0
    error_message = "asg_desired_capacity must be zero or greater."
  }
}

variable "asg_max_size" {
  description = "Maximum number of Attendance API instances"
  type        = number
  default     = 2

  validation {
    condition     = var.asg_max_size >= 1
    error_message = "asg_max_size must be at least 1."
  }
}

variable "asg_min_size" {
  description = "Minimum number of Attendance API instances"
  type        = number
  default     = 1

  validation {
    condition     = var.asg_min_size >= 0
    error_message = "asg_min_size must be zero or greater."
  }
}

variable "ami_id" {
  description = "Attendance API AMI ID generated using Packer"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.ami_id))
    error_message = "ami_id must be a valid AWS AMI ID, for example ami-0123456789abcdef0."
  }
}

variable "aws_region" {
  description = "AWS region where Attendance API resources will be managed"
  type        = string
  default     = "us-east-1"
}

variable "cost_center" {
  description = "Cost center tag applied to Attendance API resources"
  type        = string
}

variable "cpu_target_value" {
  description = "Average CPU utilization target used by the ASG scaling policy"
  type        = number
  default     = 70

  validation {
    condition     = var.cpu_target_value > 0 && var.cpu_target_value <= 100
    error_message = "cpu_target_value must be greater than 0 and less than or equal to 100."
  }
}

variable "environment" {
  description = "Deployment environment such as dev, stage, or prod"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "environment can contain only lowercase letters, numbers, and hyphens."
  }
}

variable "instance_type" {
  description = "EC2 instance type used by the Attendance API launch template"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "owner" {
  description = "Owner tag applied to Attendance API resources"
  type        = string
}

variable "ssm_instance_profile" {
  description = "Name of the existing IAM instance profile attached to Attendance API EC2 instances"
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC containing the Attendance API subnets"
  type        = string
}
