output "notification_sg_id" {
  description = "The ID of the notification security group"
  value       = aws_security_group.notification_sg.id
}

output "notification_sg_name" {
  description = "The name of the notification security group"
  value       = aws_security_group.notification_sg.name
}

output "packer_builder_security_group_id" {
  description = "Security Group ID for Packer Builder"
  value       = aws_security_group.packer_builder_sg.id
}
