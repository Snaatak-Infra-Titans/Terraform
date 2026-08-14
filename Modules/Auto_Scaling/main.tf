resource "aws_lb_target_group" "this" {
  name     = "${var.environment}-${var.application}-tg"
  port     = var.application_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  target_type = var.target_type

  health_check {
    enabled             = var.health_check_enabled
    protocol            = var.health_check_protocol
    path                = var.health_check_path
    port                = var.health_check_port
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-tg"
  })
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = var.listener_rule_paths
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-listener-rule"
  })
}

resource "aws_launch_template" "this" {
  name                   = "${var.environment}-${var.application}-lt"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "${var.environment}-${var.application}"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.common_tags, {
      Name = "${var.environment}-${var.application}-vol"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-lt"
  })
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.environment}-${var.application}-asg"
  vpc_zone_identifier = var.subnet_ids

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  target_group_arns = [
    aws_lb_target_group.this.arn
  ]

  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.application}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "this" {
  name                   = "${var.environment}-${var.application}-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.this.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.scaling_metric_type
    }

    target_value = var.scaling_target_value
  }
}
