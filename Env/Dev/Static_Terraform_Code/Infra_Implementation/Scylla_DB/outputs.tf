output "security_group_id" {
  value = aws_security_group.scylla_sg.id
}

output "security_group_name" {
  value = aws_security_group.scylla_sg.name
}
