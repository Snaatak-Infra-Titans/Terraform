resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.environment}-${var.application}-cpu-policy"
  
  autoscaling_group_name = aws_autoscaling_group.attendance_asg.name
  
  policy_type            = "TargetTrackingScaling"
  
  # Target Tracking Configuration (CPU based)
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}
