output "target_group_arn" {
  description = "ARN of the Notification Auto Scaling target group"

  value = module.notification.target_group_arn
}

output "launch_template_id" {
  description = "ID of the Notification launch template"

  value = module.notification.launch_template_id
}

output "autoscaling_group_name" {
  description = "Name of the Notification Auto Scaling Group"

  value = module.notification.autoscaling_group_name
}

output "autoscaling_policy_name" {
  description = "Name of the Notification Auto Scaling policy"

  value = module.notification.autoscaling_policy_name
}

output "listener_rule_arn" {
  description = "ARN of the Notification ALB listener rule"

  value = module.notification.listener_rule_arn
}
