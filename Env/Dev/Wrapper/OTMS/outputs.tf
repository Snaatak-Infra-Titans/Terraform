output "aws_account_id" {
  description = "AWS account verified by the wrapper guardrail."
  value       = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  description = "Dev VPC ID."
  value       = module.network_skeleton.vpc_id
}

output "subnet_ids" {
  description = "Stable logical subnet name to subnet ID mapping."
  value       = module.network_skeleton.subnet_ids
}

output "alb_dns_name" {
  description = "Shared public ALB DNS name."
  value       = module.network_skeleton.alb_dns_name
}

output "public_urls" {
  description = "Public OTMS endpoints."
  value = {
    apex = "https://otms.online"
    www  = "https://www.otms.online"
  }
}

output "ssm_instance_profile_name" {
  description = "Existing SSM-only EC2 instance profile reused by applications and databases."
  value       = data.aws_iam_instance_profile.ssm.name
}

output "deployment_phase" {
  description = "Selected deployment phase for this plan or apply."
  value       = var.deployment_phase
}

output "application_capacity" {
  description = "Application Auto Scaling group capacity selected by the deployment phase."
  value       = local.application_capacity
}

output "application_autoscaling_groups" {
  description = "Application name to Auto Scaling group name mapping."
  value       = { for name, application in module.application : name => application.autoscaling_group_name }
}

output "database_instance_ids" {
  description = "Database name to EC2 instance ID mapping for SSM-based Ansible inventory."
  value       = { for name, database in module.database : name => database.instance_id }
}

output "database_private_ips" {
  description = "Fixed database IP addresses."
  value       = { for name, database in module.database : name => database.private_ip }
}

output "database_private_dns" {
  description = "Stable private database DNS records."
  value       = { for name, record in aws_route53_record.database : name => record.fqdn }
}

output "ubuntu_2404_ami_id" {
  description = "Canonical Ubuntu 24.04 AMI selected for database instances."
  value       = data.aws_ami.ubuntu_2404.id
}
