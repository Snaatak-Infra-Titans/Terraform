output "salary_lt_id" {
  description = "The ID of the salary launch template"
  value       = aws_launch_template.salary_lt.id
}

output "salary_lt_arn" {
  description = "The ARN of the salary launch template"
  value       = aws_launch_template.salary_lt.arn
}

output "salary_lt_latest_version" {
  description = "The latest version of the salary launch template"
  value       = aws_launch_template.salary_lt.latest_version
}
