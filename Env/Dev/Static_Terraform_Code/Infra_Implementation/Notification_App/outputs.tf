output "instance_id" {
  value = aws_instance.notification_ec2.id
}

output "private_ip" {
  value = aws_instance.notification_ec2.private_ip
}
