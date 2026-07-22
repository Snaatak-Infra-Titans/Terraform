resource "aws_autoscaling_group" "notification_asg" {
  name_prefix         = "${var.environment}-${var.application}-notification-asg-"
  vpc_zone_identifier = data.aws_subnets.backend_subnets.ids

  target_group_arns   = [data.aws_lb_target_group.notification_tg.arn]

  desired_capacity          = var.asg_desired_capacity
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.notification_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.application}-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
