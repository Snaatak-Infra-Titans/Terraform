variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "QA VPC ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "qa"
}

variable "application" {
  description = "Application name"
  type        = string
  default     = "notification"
}

variable "common_tags" {
  description = "Common tags applied to AWS resources"
  type        = map(string)
  default     = {}
}

variable "application_port" {
  description = "Port on which the Notification application listens"
  type        = number
  default     = 8085
}

variable "target_group_protocol" {
  description = "Protocol used by the target group"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.target_group_protocol)
    error_message = "target_group_protocol must be HTTP or HTTPS."
  }
}

variable "target_type" {
  description = "Target type for the target group"
  type        = string
  default     = "instance"
}

variable "health_check_enabled" {
  description = "Whether target group health checks are enabled"
  type        = bool
  default     = true
}

variable "health_check_protocol" {
  description = "Protocol used for target group health checks"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.health_check_protocol)
    error_message = "health_check_protocol must be HTTP or HTTPS."
  }
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port used for health checks"
  type        = string
  default     = "traffic-port"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "Expected HTTP response codes"
  type        = string
  default     = "200"
}

variable "listener_arn" {
  description = "ARN of the existing QA ALB listener"
  type        = string
}

variable "listener_rule_priority" {
  description = "Priority of the ALB listener rule"
  type        = number
}

variable "listener_rule_paths" {
  description = "Path patterns used by the listener rule"
  type        = list(string)
}

variable "ami_id" {
  description = "Notification Golden AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "security_group_id" {
  description = "Security group ID attached to Notification instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile attached to Notification instances"
  type        = string
}

variable "subnet_ids" {
  description = "QA backend subnet IDs used by the Auto Scaling Group"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of Notification instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of Notification instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of Notification instances"
  type        = number
  default     = 1
}

variable "asg_health_check_type" {
  description = "Health check type used by the Auto Scaling Group"
  type        = string
  default     = "ELB"
}

variable "asg_health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "scaling_metric_type" {
  description = "Predefined metric used for target tracking"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "scaling_target_value" {
  description = "Target value for the scaling policy"
  type        = number
  default     = 60
}
