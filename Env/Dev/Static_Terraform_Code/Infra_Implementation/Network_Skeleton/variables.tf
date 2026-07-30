variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "application" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "destination_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}
