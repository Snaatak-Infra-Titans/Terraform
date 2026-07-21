variable "certificate_arn" {
  description = "ARN of the ACM certificate used by the HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "TLS security policy used by the HTTPS listener"
  type        = string
}

variable "frontend_port" { type = number }
variable "employee_port" { type = number }
variable "attendance_port" { type = number }
variable "salary_port" { type = number }
variable "notification_port" { type = number }

variable "frontend_health_check" { type = string }
variable "employee_health_check" { type = string }
variable "attendance_health_check" { type = string }
variable "salary_health_check" { type = string }
variable "notification_health_check" { type = string }
