# Launch Template Outputs (Ticket 431)
output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.employee_app.id
}

output "launch_template_arn" {
  description = "ARN of the Launch Template"
  value       = aws_launch_template.employee_app.arn
}

# Auto Scaling Group Outputs (Ticket 433)
output "asg_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.employee_app_asg.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.employee_app_asg.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.employee_app_asg.arn
}
