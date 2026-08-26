output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs."
  value       = { for key, subnet in aws_subnet.this : key => subnet.id }
}

output "security_group_ids" {
  description = "Map of security group keys to IDs."
  value       = { for key, security_group in aws_security_group.this : key => security_group.id }
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = var.enable_alb ? aws_lb.this[0].arn : null
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = var.enable_alb ? aws_lb.this[0].dns_name : null
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer."
  value       = var.enable_alb ? aws_lb.this[0].zone_id : null
}

output "https_listener_arn" {
  description = "ARN of the shared HTTPS listener."
  value       = var.enable_alb ? aws_lb_listener.https[0].arn : null
}

output "public_route53_record_names" {
  description = "Public DNS records created for the ALB."
  value       = { for key, record in aws_route53_record.public_alb_alias : key => record.fqdn }
}

output "private_route53_zone_association_id" {
  description = "Private hosted-zone VPC association ID."
  value       = var.enable_private_route53 ? aws_route53_zone_association.private[0].id : null
}

output "ssm_role_name" {
  description = "Name of the environment-specific SSM role."
  value       = var.enable_ssm_instance_profile ? aws_iam_role.ssm[0].name : null
}

output "ssm_instance_profile_name" {
  description = "Name of the environment-specific SSM instance profile."
  value       = var.enable_ssm_instance_profile ? aws_iam_instance_profile.ssm[0].name : null
}
