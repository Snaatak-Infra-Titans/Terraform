variable "aws_region" {
  description = "AWS region for the Dev network."
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
  description = "Team that owns the infrastructure."
  type        = string
}

variable "cost_center" {
  description = "Cost allocation tag value."
  type        = string
}

variable "tags" {
  description = "Additional tags applied to the Dev network."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the Dev VPC."
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
  description = "Dev subnet definitions."
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    route_table_type        = string
    additional_tags         = map(string)
  }))
}

variable "enable_nat_gateway" {
  description = "Create one NAT Gateway."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Public subnet key that hosts the NAT Gateway."
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

variable "enable_alb" {
  description = "Create the shared Dev ALB."
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
}

variable "alb_internal" {
  description = "Whether the ALB is internal."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable ALB deletion protection."
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "Service target groups and health checks."
  type = map(object({
    port                 = number
    protocol             = string
    target_type          = string
    health_check_path    = string
    health_check_matcher = string
  }))
}

variable "default_target_group_key" {
  description = "Default HTTPS target group key."
  type        = string
  default     = "frontend"
}

variable "listener_rules" {
  description = "HTTPS path-routing rules."
  type = map(object({
    priority         = number
    path_patterns    = list(string)
    target_group_key = string
  }))
}

variable "certificate_arn" {
  description = "Issued ACM certificate ARN used by the HTTPS listener."
  type        = string
}

variable "ssl_policy" {
  description = "TLS policy used by the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "enable_public_route53" {
  description = "Create public ALB aliases in an existing persistent zone."
  type        = bool
  default     = false
}

variable "public_route53_zone_id" {
  description = "ID of the existing otms.online public hosted zone."
  type        = string
  default     = null
}

variable "public_route53_records" {
  description = "Public DNS names for the Dev ALB."
  type        = set(string)
  default     = []
}

variable "enable_private_route53" {
  description = "Associate the persistent otms.internal zone with the Dev VPC."
  type        = bool
  default     = false
}

variable "private_route53_zone_id" {
  description = "ID of the existing otms.internal private hosted zone."
  type        = string
  default     = null
}

variable "private_dns_records" {
  description = "Optional private service records managed by Terraform."
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "enable_ssm_instance_profile" {
  description = "Create the Dev EC2 SSM role and instance profile."
  type        = bool
  default     = true
}
