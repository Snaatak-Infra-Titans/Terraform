variable "aws_region" {
  description = "AWS region for the Dev environment"
  type        = string
}


variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}


variable "application" {
  description = "Application name"
  type        = string
  default     = "notification"
}


variable "vpc_id" {
  description = "VPC ID for the Notification infrastructure"
  type        = string
}


variable "subnet_ids" {
  description = "Subnet IDs for the Notification Auto Scaling Group"
  type        = list(string)
}


variable "ami_id" {
  description = "Notification Golden AMI ID"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type for Notification"
  type        = string
  default     = "t3.small"
}


variable "security_group_id" {
  description = "Security group ID for Notification instances"
  type        = string
}


variable "iam_instance_profile_name" {
  description = "IAM instance profile for Notification instances"
  type        = string
}


variable "application_port" {
  description = "Port on which Notification is running"
  type        = number
  default     = 8080
}


variable "target_group_protocol" {
  description = "Protocol used by the Notification target group"
  type        = string
  default     = "HTTPS"
}


variable "target_type" {
  description = "Target type for the target group"
  type        = string
  default     = "instance"
}


variable "health_check_enabled" {
  description = "Enable target group health checks"
  type        = bool
  default     = true
}


variable "health_check_protocol" {
  description = "Protocol used for Notification health checks"
  type        = string
  default     = "HTTPS"
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
  description = "Number of successful health checks required"
  type        = number
  default     = 3
}


variable "unhealthy_threshold" {
  description = "Number of failed health checks before unhealthy"
  type        = number
  default     = 3
}


variable "health_check_matcher" {
  description = "Expected health check response code"
  type        = string
  default     = "200"
}


variable "listener_arn" {
  description = "ARN of the existing ALB listener"
  type        = string
}


variable "listener_rule_priority" {
  description = "Priority of the ALB listener rule"
  type        = number
}


variable "listener_rule_paths" {
  description = "Path patterns for the Notification listener rule"
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
  description = "Auto Scaling Group health check type"
  type        = string
  default     = "ELB"
}


variable "asg_health_check_grace_period" {
  description = "ASG health check grace period in seconds"
  type        = number
  default     = 300
}


variable "scaling_metric_type" {
  description = "Metric used for target tracking scaling"
  type        = string
  default     = "ASGAverageCPUUtilization"
}


variable "scaling_target_value" {
  description = "Target value for the scaling policy"
  type        = number
  default     = 70
}


variable "common_tags" {
  description = "Common tags for Notification resources"
  type        = map(string)

  default = {
    Environment = "dev"
    Application = "notification"
  }
}
