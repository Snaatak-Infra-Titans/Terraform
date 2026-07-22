data "aws_lb_target_group" "notification_tg" {
  name = "${var.environment}-${var.application}-notification-tg"
}
