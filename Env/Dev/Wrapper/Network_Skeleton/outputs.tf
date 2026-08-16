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
  description = "Map of Dev public subnet IDs."
  value       = module.network_skeleton.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of Dev private subnet IDs."
  value       = module.network_skeleton.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Dev internet gateway."
  value       = module.network_skeleton.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID of the Dev NAT gateway."
  value       = module.network_skeleton.nat_gateway_id
}

output "nat_eip_public_ip" {
  description = "Public IP allocated to the Dev NAT gateway."
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
