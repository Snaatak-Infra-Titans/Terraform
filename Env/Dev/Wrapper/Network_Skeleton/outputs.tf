output "vpc_id" {
  description = "ID of the Dev VPC."
  value       = module.network_skeleton.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the Dev VPC."
  value       = module.network_skeleton.vpc_cidr_block
}

output "subnet_ids" {
  description = "Map of all Dev subnet IDs."
  value       = module.network_skeleton.subnet_ids
}

output "public_subnet_ids" {
  description = "Map of public Dev subnet IDs."
  value       = module.network_skeleton.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of private Dev subnet IDs."
  value       = module.network_skeleton.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Dev Internet Gateway."
  value       = module.network_skeleton.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID of the Dev NAT Gateway."
  value       = module.network_skeleton.nat_gateway_id
}

output "nat_eip_public_ip" {
  description = "Public IP allocated to the Dev NAT Gateway."
  value       = module.network_skeleton.nat_eip_public_ip
}

output "public_route_table_id" {
  description = "ID of the Dev public route table."
  value       = module.network_skeleton.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the Dev private route table."
  value       = module.network_skeleton.private_route_table_id
}

output "security_group_ids" {
  description = "Map of Dev security group IDs."
  value       = module.network_skeleton.security_group_ids
}

output "network_acl_ids" {
  description = "Map of Dev network ACL IDs."
  value       = module.network_skeleton.network_acl_ids
}

output "alb_dns_name" {
  description = "DNS name of the Dev ALB."
  value       = module.network_skeleton.alb_dns_name
}

output "alb_security_group_id" {
  description = "Security group ID of the Dev ALB."
  value       = module.network_skeleton.alb_security_group_id
}

output "target_group_arns" {
  description = "Map of Dev service target-group ARNs."
  value       = module.network_skeleton.target_group_arns
}

output "listener_rule_arns" {
  description = "Map of Dev HTTPS listener-rule ARNs."
  value       = module.network_skeleton.listener_rule_arns
}

output "public_route53_record_names" {
  description = "Public DNS names managed for the Dev ALB."
  value       = module.network_skeleton.public_route53_record_names
}

output "ssm_role_name" {
  description = "Dev SSM IAM role name."
  value       = module.network_skeleton.ssm_role_name
}

output "ssm_instance_profile_name" {
  description = "Dev SSM instance profile name."
  value       = module.network_skeleton.ssm_instance_profile_name
}
