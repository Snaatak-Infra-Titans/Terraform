resource "aws_lb_listener_rule" "notification_routing" {
  listener_arn = data.aws_lb_listener.app_listener.arn
  priority     = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.notification_tg.arn
  }

  condition {
    path_pattern {
      values = [var.app_path_pattern]
    }
  }

  tags = {
    Name = "${var.environment}-${var.application}-listener-rule"
  }
}
