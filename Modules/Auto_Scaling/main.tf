resource "aws_lb_target_group" "this" {
  name                 = "${var.environment}-${var.application}-tg"
  port                 = var.application_port
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.vpc_id
  deregistration_delay = 30

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = var.health_check_path
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = var.health_check_matcher
  }

  tags = merge(var.common_tags, {
    Name    = "${var.environment}-${var.application}-tg"
    Service = var.application
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
  name_prefix            = "${var.environment}-${var.application}-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  update_default_version = true

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted             = true
      delete_on_termination = true
      volume_type           = "gp3"
      volume_size           = var.root_volume_size
    }
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
      Name = "${var.environment}-${var.application}-volume"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.application}-launch-template"
  })
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.environment}-${var.application}-asg"
  vpc_zone_identifier       = var.subnet_ids
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  target_group_arns         = [aws_lb_target_group.this.arn]
  health_check_type         = "ELB"
  health_check_grace_period = var.asg_health_check_grace_period

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 0
      instance_warmup        = var.asg_health_check_grace_period
    }

    triggers = ["tag"]
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

resource "aws_autoscaling_policy" "cpu" {
  name                   = "${var.environment}-${var.application}-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.scaling_target_value
  }
}
