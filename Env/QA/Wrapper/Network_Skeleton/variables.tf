variable "aws_region" {
  description = "AWS region in which the QA network is deployed."
  type        = string
}

variable "application" {
  description = "Application name used in resource names and tags."
  type        = string
}

variable "environment" {
  description = "Environment name used in resource names and tags."
  type        = string

  validation {
    condition     = var.environment == "qa"
    error_message = "This wrapper is only for the QA environment."
  }
}

variable "owner" {
  description = "Team that owns the infrastructure."
  type        = string
}

variable "cost_center" {
  description = "Cost allocation value applied to resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the QA VPC."
  type        = string
}

variable "enable_dns_support" {
  description = "Whether DNS resolution is enabled for the QA VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled for the QA VPC."
  type        = bool
  default     = true
}

variable "subnets" {
  description = "QA subnet definitions passed to the Network Skeleton module."
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
    error_message = "Each route_table_type must be public or private."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create the QA NAT gateway."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Public subnet key in which the NAT gateway is created."
  type        = string
}

variable "security_groups" {
  description = "Security groups passed to the Network Skeleton module."
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
  description = "Network ACLs passed to the Network Skeleton module."
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
  description = "Additional tags applied to QA network resources."
  type        = map(string)
  default     = {}
}
