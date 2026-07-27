variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "ami_id" {
  description = "Attendance application AMI ID"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]+$", var.ami_id))
    error_message = "AMI ID must start with ami-, for example ami-0b1fc7bc559d9d69f."
  }
}



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


variable "instance_type" {
  type = string
}

variable "ssm_instance_profile" {
  type        = string
  description = "Name of the manually created IAM Instance Profile for SSM"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in ASG"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in ASG"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in ASG"
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization percentage for ASG scaling"
}
