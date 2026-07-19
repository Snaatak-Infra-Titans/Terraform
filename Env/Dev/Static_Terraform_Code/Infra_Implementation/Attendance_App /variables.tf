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

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0f5ee92e2d63afc18"
}

variable "key_name" {
  type    = string
  default = "sprint_3.1"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "desired_capacity" {
  type    = number
  default = 1
}
