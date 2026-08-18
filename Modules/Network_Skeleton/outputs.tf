############################################
# Application Load Balancer Outputs
############################################

output "alb_arn" {
  description = "ARN of the Application Load Balancer"

  value = var.enable_alb ? aws_lb.this[0].arn : null
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"

  value = var.enable_alb ? aws_lb.this[0].dns_name : null
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer"

  value = var.enable_alb ? aws_lb.this[0].zone_id : null
}

############################################
# Listener Outputs
############################################

output "http_listener_arn" {
  description = "ARN of the HTTP ALB listener"

  value = var.enable_alb ? aws_lb_listener.http[0].arn : null
}

output "https_listener_arn" {
  description = "ARN of the HTTPS ALB listener"

  value = var.enable_alb ? aws_lb_listener.https[0].arn : null
}

############################################
# Public Route53 Outputs
############################################

output "public_route53_record_names" {
  description = "Public Route53 DNS records created for the Application Load Balancer"

  value = {
    for key, record in aws_route53_record.public_alb_alias :
    key => record.fqdn
  }
}

############################################
# Private Route53 Outputs
############################################

output "private_route53_record_names" {
  description = "Private Route53 DNS records created for internal services"

  value = {
    for key, record in aws_route53_record.private :
    key => record.fqdn
  }
}

############################################
# Private Hosted Zone Association Output
############################################

output "private_route53_zone_association_id" {
  description = "ID of the private Route53 hosted zone VPC association"

  value = var.enable_private_route53 ? aws_route53_zone_association.private[0].id : null
}
