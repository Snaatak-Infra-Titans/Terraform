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

output "public_subnet_ids" {
  description = "Map of public subnet keys to subnet IDs."
  value = {
    for key, subnet in aws_subnet.this : key => subnet.id
    if var.subnets[key].route_table_type == "public"
  }
}

output "private_subnet_ids" {
  description = "Map of private subnet keys to subnet IDs."
  value = {
    for key, subnet in aws_subnet.this : key => subnet.id
    if var.subnets[key].route_table_type == "private"
  }
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway."
  value       = var.enable_nat_gateway ? aws_nat_gateway.this[0].id : null
}

output "nat_eip_public_ip" {
  description = "Public IP allocated to the NAT Gateway."
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}

output "security_group_ids" {
  description = "Map of security group keys to IDs."
  value       = { for key, sg in aws_security_group.this : key => sg.id }
}

output "network_acl_ids" {
  description = "Map of network ACL keys to IDs."
  value       = { for key, nacl in aws_network_acl.this : key => nacl.id }
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

output "alb_security_group_id" {
  description = "Security group ID assigned to the ALB."
  value       = var.enable_alb ? aws_security_group.this[var.alb_security_group_key].id : null
}

output "http_listener_arn" {
  description = "ARN of the HTTP redirect listener."
  value       = var.enable_alb ? aws_lb_listener.http[0].arn : null
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener."
  value       = var.enable_alb ? aws_lb_listener.https[0].arn : null
}

output "target_group_arns" {
  description = "Map of service target group ARNs."
  value       = { for key, target_group in aws_lb_target_group.this : key => target_group.arn }
}

output "listener_rule_arns" {
  description = "Map of HTTPS path-rule ARNs."
  value       = { for key, rule in aws_lb_listener_rule.this : key => rule.arn }
}

output "public_route53_record_names" {
  description = "Public DNS records created for the ALB."
  value       = { for key, record in aws_route53_record.public_alb_alias : key => record.fqdn }
}

output "private_route53_record_names" {
  description = "Private DNS records managed by this module."
  value       = { for key, record in aws_route53_record.private : key => record.fqdn }
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
