############################################
# Common / Naming Variables
############################################

variable "environment" {
  description = "Deployment environment such as dev, qa, stage, or prod"
  type        = string
}

variable "application" {
  description = "Application or service name"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to Auto Scaling resources"
  type        = map(string)
  default     = {}
}

############################################
# Network Inputs
############################################

variable "vpc_id" {
  description = "VPC ID where the target group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where Auto Scaling instances will be launched"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID attached to Auto Scaling instances"
  type        = string
}

############################################
# Target Group
############################################

variable "application_port" {
  description = "Port on which the application listens"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol used between the ALB target group and application instances"
  type        = string
  default     = "HTTP"

  validation {
    condition = contains(
      ["HTTP", "HTTPS"],
      var.target_group_protocol
    )

    error_message = "target_group_protocol must be HTTP or HTTPS."
  }
}

variable "target_type" {
  description = "Target type used by the ALB target group"
  type        = string
  default     = "instance"

  validation {
    condition = contains(
      ["instance", "ip"],
      var.target_type
    )

    error_message = "target_type must be instance or ip."
  }
}

############################################
# Target Group Health Check
############################################

variable "health_check_enabled" {
  description = "Whether target group health checks are enabled"
  type        = bool
  default     = true
}

variable "health_check_protocol" {
  description = "Protocol used by target group health checks"
  type        = string
  default     = "HTTP"

  validation {
    condition = contains(
      ["HTTP", "HTTPS"],
      var.health_check_protocol
    )

    error_message = "health_check_protocol must be HTTP or HTTPS."
  }
}

variable "health_check_path" {
  description = "Application health check path"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port used for target group health checks"
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
  description = "Number of successful health checks required before considering a target healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of failed health checks required before considering a target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "Expected HTTP response code or range for health checks"
  type        = string
  default     = "200-399"
}

############################################
# ALB Listener Rule
############################################

variable "listener_arn" {
  description = "ARN of the existing HTTPS ALB listener created by the Network Skeleton module"
  type        = string
}

variable "listener_rule_priority" {
  description = "Unique priority assigned to this listener rule"
  type        = number

  validation {
    condition = (
      var.listener_rule_priority >= 1 &&
      var.listener_rule_priority <= 50000
    )

    error_message = "listener_rule_priority must be between 1 and 50000."
  }
}

variable "listener_rule_paths" {
  description = "Path patterns routed to this application's target group"
  type        = list(string)
}

############################################
# Launch Template
############################################

variable "ami_id" {
  description = "AMI ID used by the Launch Template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Existing IAM instance profile attached to the Auto Scaling instances"
  type        = string
}

############################################
# Auto Scaling Group
############################################

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 2

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "asg_health_check_type" {
  description = "Health check type used by the Auto Scaling Group"
  type        = string
  default     = "ELB"

  validation {
    condition = contains(
      ["EC2", "ELB"],
      var.asg_health_check_type
    )

    error_message = "asg_health_check_type must be EC2 or ELB."
  }
}

variable "asg_health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

############################################
# Auto Scaling Policy
############################################

variable "scaling_metric_type" {
  description = "Predefined metric used by target tracking scaling"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "scaling_target_value" {
  description = "Target value maintained by the target tracking scaling policy"
  type        = number
  default     = 70
}
