# Lookup existing VPC by Name tag
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-vpc"]
  }
}

# Target Group for Attendance Microservice
resource "aws_lb_target_group" "attendance" {
  name        = "${var.environment}-attendance-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/api/v1/attendance/health"
    port                = "8080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-attendance-tg"
    Application = var.tag_application
    Owner       = var.tag_owner
    Environment = var.environment
    CostCenter  = var.tag_costcenter
  }
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.attendance.arn
}

output "target_group_name" {
  description = "The Name of the Target Group"
  value       = aws_lb_target_group.attendance.name
}
