variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tag_application" {
  type    = string
  default = "otms"
}

variable "tag_owner" {
  type    = string
  default = "Infra-Titans"
}

variable "tag_costcenter" {
  type    = string
  default = "Snaatak"
}
