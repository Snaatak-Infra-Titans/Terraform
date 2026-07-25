resource "aws_autoscaling_policy" "frontend_cpu_policy" {
  name                   = "${var.environment}-${var.application}-frontend-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    
    # Target CPU utilization at 70%
    target_value = 70.0
  }
}
