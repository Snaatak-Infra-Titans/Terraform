variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "application" {
  description = "Application or service name."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to Auto Scaling resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where the target group is created."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs where instances are launched."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to application instances."
  type        = string
}

variable "application_port" {
  description = "Port on which the application listens."
  type        = number
}

variable "health_check_path" {
  description = "HTTP health check path."
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Expected HTTP status code or range."
  type        = string
  default     = "200-399"
}

variable "listener_arn" {
  description = "ARN of the shared HTTPS ALB listener."
  type        = string
}

variable "listener_rule_priority" {
  description = "Unique listener rule priority."
  type        = number

  validation {
    condition     = var.listener_rule_priority >= 1 && var.listener_rule_priority <= 50000
    error_message = "listener_rule_priority must be between 1 and 50000."
  }
}

variable "listener_rule_paths" {
  description = "Path patterns routed to this application."
  type        = list(string)
}

variable "ami_id" {
  description = "Application AMI ID."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "iam_instance_profile_name" {
  description = "SSM-enabled IAM instance profile name."
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances."
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of EC2 instances."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances."
  type        = number
  default     = 2
}

variable "asg_health_check_grace_period" {
  description = "ELB health check grace period in seconds."
  type        = number
  default     = 300
}

variable "scaling_target_value" {
  description = "Target average CPU utilization percentage."
  type        = number
  default     = 70
}
