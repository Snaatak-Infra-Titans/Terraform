output "attendance_lt_id" {
  description = "The ID of the attendance launch template"
  value       = aws_launch_template.attendance_lt.id
}

output "attendance_lt_arn" {
  description = "The ARN of the notification launch template"
  value       = aws_launch_template.attendance_lt.arn
}

output "attendance_lt_latest_version" {
  description = "The latest version of the attendance launch template"
  value       = aws_launch_template.attendance_lt.latest_version
}
