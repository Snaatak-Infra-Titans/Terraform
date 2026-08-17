############################################
# Target Group Outputs
############################################

output "target_group_arn" {
  description = "ARN of the Auto Scaling target group"
  value       = aws_lb_target_group.this.arn
}

output "target_group_name" {
  description = "Name of the Auto Scaling target group"
  value       = aws_lb_target_group.this.name
}

############################################
# Listener Rule Output
############################################

output "listener_rule_arn" {
  description = "ARN of the ALB listener rule"
  value       = aws_lb_listener_rule.this.arn
}

############################################
# Launch Template Outputs
############################################

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.this.id
}

output "launch_template_arn" {
  description = "ARN of the Launch Template"
  value       = aws_launch_template.this.arn
}

############################################
# Auto Scaling Group Output
############################################

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

############################################
# Auto Scaling Policy Output
############################################

output "autoscaling_policy_name" {
  description = "Name of the Auto Scaling policy"
  value       = aws_autoscaling_policy.this.name
}
