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
# Route53 Outputs
############################################

output "route53_record_names" {
  description = "Route53 record names created for the ALB"

  value = {
    for key, record in aws_route53_record.alb_alias :
    key => record.fqdn
  }
}
