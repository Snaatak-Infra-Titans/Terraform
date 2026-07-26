output "employee_api_security_group_id" {
  description = "Security Group ID for Employee API"
  value       = aws_security_group.api_sg.id
}

output "employee_api_launch_template_id" {
  description = "Launch Template ID for Employee API"
  value       = aws_launch_template.employee_api.id
}

output "employee_api_asg_name" {
  description = "Auto Scaling Group Name"
  value       = aws_autoscaling_group.employee_api.name
}

output "employee_tg_arn" {
  description = "Employee Target Group ARN fetched from network state"
  value       = data.terraform_remote_state.network.outputs.target_group_arns["employee"]
}

output "employee_listener_rule_arn" {
  description = "Employee ALB Listener Rule ARN fetched from network state"
  value       = data.terraform_remote_state.network.outputs.listener_rule_arns["employee"]
}
