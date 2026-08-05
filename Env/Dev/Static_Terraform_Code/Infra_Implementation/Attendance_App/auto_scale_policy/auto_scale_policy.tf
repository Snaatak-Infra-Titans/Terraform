resource "aws_autoscaling_policy" "attendance_cpu_policy" {
  name                   = "${var.environment}-otms-attendance-cpu-policy"
  autoscaling_group_name = data.aws_autoscaling_group.attendance.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
