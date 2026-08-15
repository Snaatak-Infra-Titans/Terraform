output "vpc_id" {
  description = "Planned VPC identifier."
  value       = module.network_skeleton.vpc_id
}

output "subnet_ids" {
  description = "Planned subnet identifiers keyed by subnet name."
  value       = module.network_skeleton.subnet_ids
}

output "security_group_ids" {
  description = "Planned security-group identifiers keyed by name."
  value       = module.network_skeleton.security_group_ids
}
