output "notification_listener_rule_arn" {
  description = "The ARN of the fetched ALB listener rule for notification routing"
  value       = data.aws_lb_listener_rule.notification_routing.arn
}
