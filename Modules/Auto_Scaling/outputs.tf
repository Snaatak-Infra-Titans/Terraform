output "target_group_arn" {
  description = "ARN of the service target group."
  value       = aws_lb_target_group.this.arn
}

output "listener_rule_arn" {
  description = "ARN of the service listener rule."
  value       = aws_lb_listener_rule.this.arn
}

output "launch_template_id" {
  description = "ID of the launch template."
  value       = aws_launch_template.this.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling group."
  value       = aws_autoscaling_group.this.name
}
