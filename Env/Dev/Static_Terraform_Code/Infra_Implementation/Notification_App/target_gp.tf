resource "aws_lb_target_group" "notification_tg" {
  name     = "${var.environment}-${var.application}-notification-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.network_vpc.id

  health_check {
    path                = "/"            # Ise apne app ke hisaab se update kar lena
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 15
  }

  tags = {
    Name = "${var.environment}-${var.application}-notification-tg"
  }
}
