output "cpu_target_tracking_policy_arn" {
  description = "The ARN of the CPU target tracking auto scaling policy"
  value       = aws_autoscaling_policy.cpu_target_tracking.arn
}

output "cpu_target_tracking_policy_name" {
  description = "The name of the CPU target tracking auto scaling policy"
  value       = aws_autoscaling_policy.cpu_target_tracking.name
}

output "packer_builder_security_group_id" {
    value = aws_security_group.packer_builder_sg.id
}
