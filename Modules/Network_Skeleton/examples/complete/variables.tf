variable "aws_region" {
  description = "AWS region used by the CI planning fixture."
  type        = string
}

variable "application" {
  description = "Application name used in resource names and tags."
  type        = string
}

variable "environment" {
  description = "Environment name used in resource names and tags."
  type        = string
}

variable "owner" {
  description = "Owning team."
  type        = string
}

variable "cost_center" {
  description = "Cost allocation value."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "enable_dns_support" {
  description = "Whether the VPC has DNS resolution enabled."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether the VPC has DNS hostnames enabled."
  type        = bool
  default     = true
}

variable "subnets" {
  description = "Subnet definitions passed to the network module."
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    route_table_type        = string
    additional_tags         = map(string)
  }))
}

variable "enable_nat_gateway" {
  description = "Whether to include the NAT gateway in the costed plan."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Public subnet key in which the NAT gateway is placed."
  type        = string
}

variable "security_groups" {
  description = "Security groups passed to the network module."
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

variable "network_acls" {
  description = "Network ACLs passed to the network module."
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

variable "tags" {
  description = "Additional tags for CI fixture resources."
  type        = map(string)
  default     = {}
}
