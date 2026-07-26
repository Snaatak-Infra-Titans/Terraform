output "employee_api_instance_id" {
  description = "The ID of the Employee API EC2 instance"
  value       = aws_instance.employee_api.id
}

output "employee_api_private_ip" {
  description = "The private IP address of the Employee API instance"
  value       = aws_instance.employee_api.private_ip
}

output "employee_api_security_group_id" {
  description = "The ID of the custom Security Group attached to the Employee API"
  value       = aws_security_group.api_sg.id
}


output "employee_api_launch_template_id" {
  description = "The ID of the Employee API Launch Template"
  value       = aws_launch_template.employee_api.id
}


output "employee_tg_arn" {
  description = "The ARN of the Employee Target Group fetched from network state"
  value       = data.terraform_remote_state.network.outputs.target_group_arns["employee"]
}
