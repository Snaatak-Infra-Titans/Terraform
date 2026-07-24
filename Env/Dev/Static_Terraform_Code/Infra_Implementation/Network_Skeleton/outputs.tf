# -----------------------------------------------------
# VPC & Network Outputs
# -----------------------------------------------------
output "vpc_id" {
  description = "The ID of the main VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "frontend_subnet_ids" {
  description = "List of IDs of the frontend subnets"
  value       = [for subnet in aws_subnet.frontend : subnet.id]
}

output "backend_subnet_ids" {
  description = "List of IDs of the backend subnets"
  value       = [for subnet in aws_subnet.backend : subnet.id]
}

output "database_subnet_ids" {
  description = "List of IDs of the database subnets"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

# -----------------------------------------------------
# Load Balancer & Routing Outputs
# -----------------------------------------------------
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb.id
}

# -----------------------------------------------------
# Target Group Outputs
# -----------------------------------------------------
output "target_group_arns" {
  description = "Map of service names (e.g., salary, attendance) to their Target Group ARNs"
  value       = { for k, v in aws_lb_target_group.services : k => v.arn }
}

# -----------------------------------------------------
# DNS / Route 53 Outputs
# -----------------------------------------------------
output "base_domain_url" {
  description = "The root domain endpoint"
  value       = aws_route53_record.alb_alias_root.name
}

output "www_domain_url" {
  description = "The www subdomain endpoint"
  value       = aws_route53_record.alb_alias_www.name
}

# -----------------------------------------------------
# SSH Key Outputs
# -----------------------------------------------------
output "key_pair_name" {
  description = "Name of the SSH Key Pair"
  value       = aws_key_pair.main_key.key_name
}

output "private_key_pem" {
  description = "Private key content (Use 'terraform output -raw private_key_pem' to extract)"
  value       = tls_private_key.rsa_key.private_key_pem
  sensitive   = true
}
