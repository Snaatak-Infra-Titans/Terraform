output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.attendance.arn
}

output "target_group_name" {
  description = "The Name of the Target Group"
  value       = aws_lb_target_group.attendance.name
}
