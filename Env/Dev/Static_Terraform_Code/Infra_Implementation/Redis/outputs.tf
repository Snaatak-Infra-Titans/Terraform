output "security_group_id" {
  description = "Redis Security Group ID"

  value = aws_security_group.redis_sg.id
}

output "security_group_name" {
  description = "Redis Security Group Name"

  value = aws_security_group.redis_sg.name
}
