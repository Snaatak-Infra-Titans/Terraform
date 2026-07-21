variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "application" {
  type    = string
  default = "otms"
}

variable "owner" {
  type    = string
  default = "Infra-Titans"
}

variable "cost_center" {
  type    = string
  default = "Snaatak"
}

variable "vpc_name" {
  type    = string
  default = "dev-otms-vpc"
}

variable "key_name" {
  type    = string
  default = "dev-otms-key"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}
