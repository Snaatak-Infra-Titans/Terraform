output "notification_tg_arn" {
  description = "The ARN of the notification target group fetched via data source"
  value       = data.aws_lb_target_group.notification_tg.arn
}

output "notification_tg_id" {
  description = "The ID of the notification target group fetched via data source"
  value       = data.aws_lb_target_group.notification_tg.id
}
