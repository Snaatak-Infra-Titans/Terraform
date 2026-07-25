resource "aws_lb_target_group" "frontend_tg" {
  name     = "${var.environment}-${var.application}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  
  # Network skeleton state se VPC ID fetch kar rahe hain
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.environment}-${var.application}-frontend-tg"
  }
}
