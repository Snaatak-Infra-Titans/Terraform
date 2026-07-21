resource "aws_autoscaling_group" "notification_asg" {
  name_prefix         = "${var.environment}-${var.application}-notification-asg-"
  vpc_zone_identifier = data.aws_subnets.backend_subnets.ids
  target_group_arns   = [data.aws_lb_target_group.notification_tg.arn]

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  health_check_type         = "ELB" # ELB health check use karna best practice hai taaki ALB dead instances ko pehchan sake
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.notification_lt.id
    version = "$Latest"
  }

  # ASG ke through launch hone wale instances par tags propagate karne ke liye
  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.application}-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
