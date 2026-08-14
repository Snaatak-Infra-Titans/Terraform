output "target_group_arn" {
  description = "ARN of the Auto Scaling target group"

  value = aws_lb_target_group.this.arn
}

output "launch_template_id" {
  description = "ID of the Auto Scaling launch template"

  value = aws_launch_template.this.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"

  value = aws_autoscaling_group.this.name
}

output "autoscaling_policy_name" {
  description = "Name of the Auto Scaling policy"

  value = aws_autoscaling_policy.this.name
}

output "listener_rule_arn" {
  description = "ARN of the ALB listener rule"

  value = aws_lb_listener_rule.this.arn
}
