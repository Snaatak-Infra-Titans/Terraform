############################################
# Application Load Balancer
############################################

variable "enable_alb" {
  description = "Whether to create the shared Application Load Balancer"
  type        = bool
  default     = true
}

variable "alb_security_group_key" {
  description = "Key of the Security Group used by the Application Load Balancer"
  type        = string
  default     = "alb"
}

variable "alb_subnet_keys" {
  description = "Keys of the public subnets where the ALB will be created"
  type        = list(string)
}

variable "alb_internal" {
  description = "Whether the Application Load Balancer is internal"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on the Application Load Balancer"
  type        = bool
  default     = false
}

############################################
# ALB Listeners
############################################

variable "http_listener_port" {
  description = "HTTP listener port"
  type        = number
  default     = 80
}

variable "https_listener_port" {
  description = "HTTPS listener port"
  type        = number
  default     = 443
}

variable "certificate_arn" {
  description = "ACM certificate ARN used by the HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy used by the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

############################################
# Route53
############################################

variable "enable_route53" {
  description = "Whether to create Route53 alias records for the ALB"
  type        = bool
  default     = true
}

variable "route53_zone_id" {
  description = "Existing Route53 hosted zone ID"
  type        = string
}

variable "route53_records" {
  description = "DNS record names that should point to the shared ALB"
  type        = set(string)
  default     = []
}
