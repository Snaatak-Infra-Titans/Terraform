variable "aws_region" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_route_table_id" {
  type = string
}

variable "nat_gateway_name" {
  type = string
}

variable "eip_name" {
  type = string
}

variable "destination_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}
