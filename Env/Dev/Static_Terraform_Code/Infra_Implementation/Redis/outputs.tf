output "instance_id" {
  description = "Redis EC2 Instance ID"

  value = aws_instance.redis.id
}

output "private_ip" {
  description = "Redis Private IP Address"

  value = aws_instance.redis.private_ip
}

output "availability_zone" {
  description = "Availability Zone of Redis EC2"

  value = aws_instance.redis.availability_zone
}

output "security_group_id" {
  description = "Redis Security Group ID"

  value = aws_security_group.redis_sg.id
}

output "security_group_name" {
  description = "Redis Security Group Name"

  value = aws_security_group.redis_sg.name
}
