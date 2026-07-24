resource "aws_autoscaling_group" "notification_asg" {
  name                = "${var.environment}-${var.application}-notification-asg"
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = data.aws_subnets.backend_subnets.ids

  # Target Group created by Network Skeleton (fetched via data source)
  target_group_arns = [data.aws_lb_target_group.notification_tg.arn]

  launch_template {
    id      = aws_launch_template.notification_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.application}-notification"
    propagate_at_launch = true
  }

tag {
    key                 = "Application"
    value               = var.application
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.owner
    propagate_at_launch = true
  }

  tag {
    key                 = "CostCenter"
    value               = var.cost_center
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
