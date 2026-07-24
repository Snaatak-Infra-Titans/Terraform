output "notification_asg_id" {
  description = "The ID of the notification Auto Scaling Group"
  value       = aws_autoscaling_group.notification_asg.id
}

output "notification_asg_name" {
  description = "The name of the notification Auto Scaling Group"
  value       = aws_autoscaling_group.notification_asg.name
}

output "notification_asg_arn" {
  description = "The ARN of the notification Auto Scaling Group"
  value       = aws_autoscaling_group.notification_asg.arn
}

output "packer_builder_security_group_id" {
    value = aws_security_group.packer_builder_sg.id
}
