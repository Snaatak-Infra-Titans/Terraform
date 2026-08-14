############################################
# Common / Naming Variables
############################################

variable "application" {
  description = "Application name used for naming and tagging resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, qa, stage, or prod"
  type        = string
}

variable "owner" {
  description = "Owner of the infrastructure resources"
  type        = string
}

variable "cost_center" {
  description = "Cost center tag"
  type        = string
}

variable "tags" {
  description = "Additional custom tags to apply to resources"
  type        = map(string)
  default     = {}
}

############################################
# VPC
############################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

############################################
# Subnets
############################################

variable "subnets" {
  description = "Map of subnet configurations"

  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    route_table_type        = string
    additional_tags         = map(string)
  }))

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      contains(["public", "private"], subnet.route_table_type)
    ])

    error_message = "route_table_type must be either public or private."
  }
}

############################################
# NAT Gateway
############################################

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Key of the public subnet where the NAT Gateway will be created"
  type        = string
}

############################################
# Security Groups
############################################

variable "security_groups" {
  description = "Map of Security Groups with ingress and egress rules"

  type = map(object({
    description = string

    ingress = list(object({
      description               = string
      from_port                 = number
      to_port                   = number
      protocol                  = string
      cidr_ipv4                 = string
      source_security_group_key = string
    }))

    egress = list(object({
      description               = string
      from_port                 = number
      to_port                   = number
      protocol                  = string
      cidr_ipv4                 = string
      source_security_group_key = string
    }))

    additional_tags = map(string)
  }))

  default = {}
}

############################################
# Network ACLs
############################################

variable "network_acls" {
  description = "Map of Network ACLs, subnet associations and rules"

  type = map(object({
    subnet_keys = list(string)

    ingress = list(object({
      rule_number = number
      protocol    = string
      rule_action = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))

    egress = list(object({
      rule_number = number
      protocol    = string
      rule_action = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))

    additional_tags = map(string)
  }))

  default = {}
}
