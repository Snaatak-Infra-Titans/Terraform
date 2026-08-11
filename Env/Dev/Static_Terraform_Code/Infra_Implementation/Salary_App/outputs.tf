output "salary_lt_id" {
  description = "The ID of the Salary Launch Template"
  value       = aws_launch_template.salary_lt.id
}

output "salary_lt_arn" {
  description = "The ARN of the Salary Launch Template"
  value       = aws_launch_template.salary_lt.arn
}

output "salary_lt_latest_version" {
  description = "The latest version of the Salary Launch Template"
  value       = aws_launch_template.salary_lt.latest_version
}
