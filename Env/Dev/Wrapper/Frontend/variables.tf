variable "aws_region" {
  description = "AWS region for Dev environment"
  type        = string
}

variable "vpc_id" {
  description = "Dev VPC ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "application" {
  description = "Application name used for resource naming"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to AWS resources"
  type        = map(string)
}

variable "application_port" {
  description = "Frontend application port"
  type        = number
}

variable "target_group_protocol" {
  description = "Target group protocol"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Target group target type"
  type        = string
  default     = "instance"
}

variable "health_check_enabled" {
  description = "Enable target group health check"
  type        = bool
  default     = true
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Frontend health check path"
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
  description = "Successful health checks required"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Failed health checks required"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "Expected HTTP response code"
  type        = string
  default     = "200"
}

variable "listener_arn" {
  description = "ARN of the existing Dev ALB listener"
  type        = string
}

variable "listener_rule_priority" {
  description = "Unique ALB listener rule priority"
  type        = number
}

variable "listener_rule_paths" {
  description = "Frontend ALB path patterns"
  type        = list(string)
}

variable "ami_id" {
  description = "Frontend Golden AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Frontend EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_id" {
  description = "Frontend security group ID"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile attached to Frontend instances"
  type        = string
}

variable "subnet_ids" {
  description = "Private Frontend subnet IDs"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of Frontend instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of Frontend instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of Frontend instances"
  type        = number
  default     = 2
}

variable "asg_health_check_type" {
  description = "ASG health check type"
  type        = string
  default     = "ELB"
}

variable "asg_health_check_grace_period" {
  description = "ASG health check grace period"
  type        = number
  default     = 300
}

variable "scaling_metric_type" {
  description = "Target tracking scaling metric"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "scaling_target_value" {
  description = "Target CPU utilization"
  type        = number
  default     = 50
}
