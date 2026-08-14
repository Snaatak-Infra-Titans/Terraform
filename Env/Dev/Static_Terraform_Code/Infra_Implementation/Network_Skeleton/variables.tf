variable "aws_region" { type = string }
variable "environment" { type = string }
variable "application" { type = string }
variable "cost_center" { type = string }
variable "owner" { type = string }
variable "vpc_name" { type = string }

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}
