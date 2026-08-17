output "target_group_arn" {
  description = "Frontend target group ARN"
  value       = module.frontend.target_group_arn
}

output "launch_template_id" {
  description = "Frontend launch template ID"
  value       = module.frontend.launch_template_id
}

output "autoscaling_group_name" {
  description = "Frontend Auto Scaling Group name"
  value       = module.frontend.autoscaling_group_name
}

output "autoscaling_policy_name" {
  description = "Frontend Auto Scaling policy name"
  value       = module.frontend.autoscaling_policy_name
}

output "listener_rule_arn" {
  description = "Frontend ALB listener rule ARN"
  value       = module.frontend.listener_rule_arn
}
