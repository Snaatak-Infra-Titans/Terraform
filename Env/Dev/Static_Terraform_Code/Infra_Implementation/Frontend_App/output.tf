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

output "frontend_asg_id" {
  description = "The ID of the Frontend Auto Scaling Group"
  value       = aws_autoscaling_group.frontend_asg.id
}

output "frontend_asg_name" {
  description = "The Name of the Frontend Auto Scaling Group"
  value       = aws_autoscaling_group.frontend_asg.name
}
