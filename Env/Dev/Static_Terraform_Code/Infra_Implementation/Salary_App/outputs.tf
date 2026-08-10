output "salary_listener_rule_arn" {
  description = "The ARN of the fetched ALB listener rule for salary routing"
  value       = data.aws_lb_listener_rule.salary_routing.arn
}
