variable "aws_region" {
  description = "AWS region"
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
  description = "Infrastructure owner"
  type        = string
}

variable "cost_center" {
  description = "Cost center"
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
}

variable "public_subnet_a_name" {
  description = "Name tag of existing public subnet A"
  type        = string
}

variable "public_subnet_b_name" {
  description = "Name tag of existing public subnet B"
  type        = string
}

variable "frontend_port" {
  description = "Frontend application port"
  type        = number
}

variable "employee_port" {
  description = "Employee API port"
  type        = number
}

variable "attendance_port" {
  description = "Attendance API port"
  type        = number
}

variable "salary_port" {
  description = "Salary API port"
  type        = number
}

variable "notification_port" {
  description = "Notification API port"
  type        = number
}

variable "frontend_health_check" {
  description = "Frontend target group health-check path"
  type        = string
}

variable "employee_health_check" {
  description = "Employee API target group health-check path"
  type        = string
}

variable "attendance_health_check" {
  description = "Attendance API target group health-check path"
  type        = string
}

variable "salary_health_check" {
  description = "Salary API target group health-check path"
  type        = string
}

variable "notification_health_check" {
  description = "Notification API target group health-check path"
  type        = string
}
