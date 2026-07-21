variable "hosted_zone_name" {
  description = "Name of the public Route 53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "DNS record that will point to the ALB"
  type        = string
}
