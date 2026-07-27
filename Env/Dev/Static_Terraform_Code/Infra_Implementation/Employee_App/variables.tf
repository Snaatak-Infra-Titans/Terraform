# --- Environment & Naming Variables ---
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  default     = "employee"
}

# --- Mandatory Tag Variables ---
variable "owner" {
  description = "Owner tag value"
  type        = string
  default     = "Pawan"
}

variable "cost_center" {
  description = "Cost Center tag value"
  type        = string
  default     = "CC-EMPLOYEE-DEV"
}

# --- Launch Template Variables ---
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_ids" {
  description = "List of Security Group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

# --- Auto Scaling Group Variables (Added for Ticket 433) ---
variable "vpc_zone_identifier" {
  description = "List of subnet IDs where ASG will launch instances"
  type        = list(string)
}

variable "asg_min_size" {
  description = "Minimum size of Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity of Auto Scaling Group"
  type        = number
  default     = 1
}

variable "target_group_arns" {
  description = "List of Target Group ARNs to attach to the ASG"
  type        = list(string)
  default     = []
}
