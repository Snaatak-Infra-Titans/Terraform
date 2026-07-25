output "frontend_launch_template_id" {
  description = "The ID of the Frontend Launch Template"
  value       = aws_launch_template.frontend.id
}

output "frontend_launch_template_latest_version" {
  description = "The latest version of the Frontend Launch Template"
  value       = aws_launch_template.frontend.latest_version
}

output "frontend_security_group_id" {
  description = "The ID of the Frontend Security Group"
  value       = aws_security_group.frontend_sg.id
}

output "frontend_tg_arn" {
  description = "The ARN of the frontend Target Group fetched from network state"
  value       = data.terraform_remote_state.network.outputs.target_group_arns["frontend"]
}
