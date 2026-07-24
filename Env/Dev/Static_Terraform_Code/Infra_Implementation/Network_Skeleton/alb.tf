locals {
  alb_name           = "${var.environment}-${var.application}-alb"
  alb_security_group = "${var.environment}-${var.application}-alb-sg"

  target_groups = {
    frontend     = { name = "${var.environment}-${var.application}-frontend-tg",     port = var.frontend_port,     health_check_path = var.frontend_health_check }
    employee     = { name = "${var.environment}-${var.application}-employee-tg",     port = var.employee_port,     health_check_path = var.employee_health_check }
    attendance   = { name = "${var.environment}-${var.application}-attendance-tg",   port = var.attendance_port,   health_check_path = var.attendance_health_check }
    salary       = { name = "${var.environment}-${var.application}-salary-tg",       port = var.salary_port,       health_check_path = var.salary_health_check }
    notification = { name = "${var.environment}-${var.application}-notification-tg", port = var.notification_port, health_check_path = var.notification_health_check }
  }

  listener_rules = {
    employee     = { priority = 10, paths = ["/api/v1/employee/*"] }
    attendance   = { priority = 20, paths = ["/api/v1/attendance/*"] }
    salary       = { priority = 30, paths = ["/actuator/*"] }
    notification = { priority = 40, paths = ["/api/v1/notification/*"] }
  }
}

resource "aws_security_group" "alb" {
  name        = local.alb_security_group
  description = "Security group for ${local.alb_name}"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name        = local.alb_security_group
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow outbound traffic from the ALB"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb" "this" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public["a"].id,
    aws_subnet.public["b"].id
  ]

  enable_deletion_protection = false

  tags = {
    Name        = local.alb_name
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_lb_target_group" "services" {
  for_each = local.target_groups

  name        = each.value.name
  port        = each.value.port
  protocol    = "HTTP"
  target_type = "instance"
  
  vpc_id      = aws_vpc.main_vpc.id

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = each.value.name
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Service     = each.key
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = var.certificate_arn
  ssl_policy      = var.ssl_policy

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services["frontend"].arn
  }
}

resource "aws_lb_listener_rule" "services" {
  for_each = local.listener_rules

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services[each.key].arn
  }

  condition {
    path_pattern {
      values = each.value.paths
    }
  }
}
