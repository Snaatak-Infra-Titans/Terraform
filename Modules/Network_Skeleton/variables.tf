variable "application" {
  description = "Application name used in resource names and tags."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev or qa."
  type        = string
}

variable "owner" {
  description = "Team that owns the infrastructure."
  type        = string
}

variable "cost_center" {
  description = "Cost allocation tag value."
  type        = string
}

variable "tags" {
  description = "Additional tags applied to all supported resources."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "subnets" {
  description = "Subnet definitions keyed by a stable logical name."
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
    error_message = "Every subnet route_table_type must be public or private."
  }
}

variable "enable_nat_gateway" {
  description = "Create one NAT Gateway for the private route table."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Key of the public subnet that hosts the NAT Gateway."
  type        = string
}

variable "security_groups" {
  description = "Security groups and their standalone ingress and egress rules."
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
  description = "Network ACLs, rules and subnet associations."
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

variable "enable_alb" {
  description = "Create the shared Application Load Balancer and service routing."
  type        = bool
  default     = true
}

variable "alb_security_group_key" {
  description = "Security group map key assigned to the ALB."
  type        = string
  default     = "alb"
}

variable "alb_subnet_keys" {
  description = "Public subnet keys used by the ALB."
  type        = list(string)
  default     = []
}

variable "alb_internal" {
  description = "Create an internal ALB instead of an internet-facing ALB."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable ALB deletion protection."
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "Target groups created for frontend and backend services."
  type = map(object({
    port                 = number
    protocol             = string
    target_type          = string
    health_check_path    = string
    health_check_matcher = string
  }))
  default = {}
}

variable "default_target_group_key" {
  description = "Target group used by the default HTTPS listener action."
  type        = string
  default     = "frontend"
}

variable "listener_rules" {
  description = "HTTPS path rules keyed by a logical rule name."
  type = map(object({
    priority         = number
    path_patterns    = list(string)
    target_group_key = string
  }))
  default = {}
}

variable "http_listener_port" {
  description = "HTTP listener port that redirects to HTTPS."
  type        = number
  default     = 80
}

variable "https_listener_port" {
  description = "HTTPS listener port."
  type        = number
  default     = 443
}

variable "certificate_arn" {
  description = "Issued ACM certificate ARN for the HTTPS listener."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "TLS policy used by the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "enable_public_route53" {
  description = "Create public Alias A records in an existing persistent hosted zone."
  type        = bool
  default     = false
}

variable "public_route53_zone_id" {
  description = "ID of the existing persistent public hosted zone."
  type        = string
  default     = null
}

variable "public_route53_records" {
  description = "Public DNS names that resolve to the ALB."
  type        = set(string)
  default     = []
}

variable "enable_private_route53" {
  description = "Associate an existing persistent private hosted zone with this VPC."
  type        = bool
  default     = false
}

variable "private_route53_zone_id" {
  description = "ID of the existing persistent private hosted zone."
  type        = string
  default     = null
}

variable "private_dns_records" {
  description = "Optional records in the persistent private hosted zone."
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "enable_ssm_instance_profile" {
  description = "Create an EC2 role and instance profile for AWS Systems Manager."
  type        = bool
  default     = true
}
