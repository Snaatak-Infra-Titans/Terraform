variable "aws_region" {
  description = "AWS region where the Attendance API instance will be created"
  type        = string
}

variable "ami_id" {
  description = "Attendance API AMI ID created using Packer"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]+$", var.ami_id))
    error_message = "AMI ID must start with ami-, for example ami-0b1fc7bc559d9d69f."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the Attendance API"
  type        = string
  default     = "t3.small"
}

variable "vpc_name" {
  description = "Name tag of the existing OTMS VPC"
  type        = string
}

variable "private_subnet_name" {
  description = "Name tag of the existing private subnet for the Attendance API"
  type        = string
}

variable "attendance_security_group_name" {
  description = "Name tag of the existing Attendance API security group"
  type        = string
}

variable "ssm_instance_profile_name" {
  description = "Name of the existing IAM instance profile used for SSM access"
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
  description = "Team responsible for managing the resource"
  type        = string
}

variable "cost_center" {
  description = "Cost center associated with the resource"
  type        = string
}
