output "notification_listener_rule_arn" {
  description = "The ARN of the fetched ALB listener rule for notification routing"
  value       = data.aws_lb_listener_rule.notification_routing.arn
}

output "packer_builder_security_group_id" {
  description = "Security Group ID for Packer Builder"
  value       = aws_security_group.packer_builder_sg.id
}
