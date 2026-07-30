output "instance_id" {
  value = aws_instance.notification.id
}

output "private_ip" {
  value = aws_instance.notification.private_ip
}
