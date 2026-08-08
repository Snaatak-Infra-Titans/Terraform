output "salary_asg_id" {
  description = "The ID of the Salary Auto Scaling Group"
  value       = aws_autoscaling_group.salary_asg.id
}

output "salary_asg_name" {
  description = "The name of the Salary Auto Scaling Group"
  value       = aws_autoscaling_group.salary_asg.name
}

output "salary_asg_arn" {
  description = "The ARN of the Salary Auto Scaling Group"
  value       = aws_autoscaling_group.salary_asg.arn
}

output "salary_asg_desired_capacity" {
  description = "The desired capacity of the Salary Auto Scaling Group"
  value       = aws_autoscaling_group.salary_asg.desired_capacity
}

output "salary_asg_min_size" {
  description = "The minimum size of the Salary Auto Scaling Group"
  value       = aws_autoscaling_group.salary_asg.min_size
}

output "salary_asg_max_size" {
  description = "The maximum size of the Salary Auto Scaling Group"
  value       = aws_autoscaling_group.salary_asg.max_size
}
