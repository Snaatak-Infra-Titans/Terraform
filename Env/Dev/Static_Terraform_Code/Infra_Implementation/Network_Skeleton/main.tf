locals {
  alb_name           = "${var.environment}-${var.application}-alb"
  alb_security_group = "${var.environment}-${var.application}-alb-sg"

  target_groups = {
    frontend = {
      name              = "${var.environment}-${var.application}-frontend-tg"
      port              = var.frontend_port
      health_check_path = var.frontend_health_check
    }

    employee = {
      name              = "${var.environment}-${var.application}-employee-tg"
      port              = var.employee_port
      health_check_path = var.employee_health_check
    }

    attendance = {
      name              = "${var.environment}-${var.application}-attendance-tg"
      port              = var.attendance_port
      health_check_path = var.attendance_health_check
    }

    salary = {
      name              = "${var.environment}-${var.application}-salary-tg"
      port              = var.salary_port
      health_check_path = var.salary_health_check
    }

    notification = {
      name              = "${var.environment}-${var.application}-notification-tg"
      port              = var.notification_port
      health_check_path = var.notification_health_check
    }
  }

  listener_rules = {
    employee = {
      priority = 10
      paths    = ["/api/v1/employee/*"]
    }

    attendance = {
      priority = 20
      paths    = ["/api/v1/attendance/*"]
    }

    salary = {
      priority = 30
      paths    = ["/actuator/*"]
    }

    notification = {
      priority = 40
      paths    = ["/api/v1/notification/*"]
    }
  }
}

############################################
# Security Group
############################################

resource "aws_security_group" "alb" {

  name        = local.alb_security_group
  description = "Security Group for ALB"

  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = local.alb_security_group
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"

  from_port = var.http_port
  to_port   = var.http_port

  description = "Allow HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "https" {

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"

  from_port = var.https_port
  to_port   = var.https_port

  description = "Allow HTTPS"
}

resource "aws_vpc_security_group_egress_rule" "all" {

  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow All Outbound"
}

############################################
# Application Load Balancer
############################################

resource "aws_lb" "this" {

  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = local.alb_name
  }
}

############################################
# Target Groups
############################################

resource "aws_lb_target_group" "services" {

  for_each = local.target_groups

  name        = each.value.name
  port        = each.value.port
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = data.aws_vpc.main.id

  health_check {

    enabled = true

    protocol = "HTTP"
    path     = each.value.health_check_path

    port = "traffic-port"

    matcher = "200-399"

    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = each.value.name
  }
}

############################################
# HTTP Listener
############################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn

  port     = var.http_port
  protocol = "HTTP"

  default_action {

    type = "redirect"

    redirect {

      port     = "443"
      protocol = "HTTPS"

      status_code = "HTTP_301"
    }
  }
}

############################################
# HTTPS Listener
############################################

resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.this.arn

  port     = var.https_port
  protocol = "HTTPS"

  certificate_arn = var.certificate_arn
  ssl_policy      = var.ssl_policy

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.services["frontend"].arn
  }
}

############################################
# Listener Rules
############################################

resource "aws_lb_listener_rule" "services" {

  for_each = local.listener_rules

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.services[each.key].arn
  }

  condition {

    path_pattern {

      values = each.value.paths
    }
  }
}
