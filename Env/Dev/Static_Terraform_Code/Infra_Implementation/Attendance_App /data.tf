data "aws_autoscaling_group" "attendance" {
  name = "${var.environment}-otms-attendance-asg"
}
