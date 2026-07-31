# Target Group for Attendance Microservice
data "aws_lb_target_group" "attendance" {
  name = "${var.environment}-otms-attendance-tg"
}
