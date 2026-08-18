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


variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "public_subnet_a_id" {
  description = "Existing Public Subnet A ID"
  type        = string
}

variable "public_subnet_b_id" {
  description = "Existing Public Subnet B ID"
  type        = string
}


variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}


variable "frontend_port" {
  type = number
}

variable "employee_port" {
  type = number
}

variable "attendance_port" {
  type = number
}

variable "salary_port" {
  type = number
}

variable "notification_port" {
  type = number
}



variable "certificate_arn" {
  type = string
}

variable "ssl_policy" {
  type = string
}


variable "frontend_health_check" {
  type = string
}

variable "employee_health_check" {
  type = string
}

variable "attendance_health_check" {
  type = string
}

variable "salary_health_check" {
  type = string
}

variable "notification_health_check" {
  type = string
}
