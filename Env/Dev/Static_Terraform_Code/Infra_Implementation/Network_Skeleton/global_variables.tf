variable "aws_region" { type = string }
variable "environment" { type = string }
variable "application" { type = string }
variable "cost_center" { type = string }
variable "owner" { type = string }

variable "public_cidr" {
  type = string
}

variable "frontend_cidr" {
  type = string
}

variable "backend_cidr" {
  type = string
}

variable "database_cidr" {
  type = string
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "redis_port" {
  type = number
}

variable "postgres_port" {
  type = number
}

variable "scylla_port" {
  type = number
}

variable "ephemeral_from_port" {
  type = number
}

variable "ephemeral_to_port" {
  type = number
}
