variable "salary_ami_id" {
  description = "AMI ID of the Salary Golden AMI"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "instance_profile_name" {
  description = "IAM Instance Profile for SSM"
  type        = string
}

variable "salary_security_group_id" {
  description = "Security Group for Salary EC2"
  type        = string
}

variable "application" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "cost_center" {
  type = string
}
