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

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
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

variable "app_path_pattern" {
  type        = string
  description = "Path pattern for routing API traffic to the Notification app"
}

variable "listener_rule_priority" {
  type        = number
  description = "Priority for the ALB listener rule"
}
