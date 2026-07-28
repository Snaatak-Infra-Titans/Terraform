output "salary_sg_id" {
  description = "The ID of the notification security group"
  value       = aws_security_group.salary_sg.id
}

output "salary_sg_name" {
  description = "The name of the salary security group"
  value       = aws_security_group.salary_sg.name
}
