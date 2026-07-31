variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tag_application" {
  type    = string
  default = "Attendance-App"
}

variable "tag_owner" {
  type    = string
  default = "Bhawna"
}

variable "tag_costcenter" {
  type    = string
  default = "Dev-Cost-Center"
}
