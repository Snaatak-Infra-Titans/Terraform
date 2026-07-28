output "cpu_target_tracking_policy_arn" {
  description = "The ARN of the CPU target tracking auto scaling policy"
  value       = aws_autoscaling_policy.cpu_target_tracking.arn
}

output "cpu_target_tracking_policy_name" {
  description = "The name of the CPU target tracking auto scaling policy"
  value       = aws_autoscaling_policy.cpu_target_tracking.name
}
