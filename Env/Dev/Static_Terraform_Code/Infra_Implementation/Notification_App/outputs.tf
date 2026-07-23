output "notification_lt_id" {
  description = "The ID of the notification launch template"
  value       = aws_launch_template.notification_lt.id
}

output "notification_lt_arn" {
  description = "The ARN of the notification launch template"
  value       = aws_launch_template.notification_lt.arn
}

output "notification_lt_latest_version" {
  description = "The latest version of the notification launch template"
  value       = aws_launch_template.notification_lt.latest_version
}
