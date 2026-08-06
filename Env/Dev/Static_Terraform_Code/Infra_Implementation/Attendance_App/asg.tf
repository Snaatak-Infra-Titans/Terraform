resource "aws_autoscaling_group" "attendance_api" {
  name = "${var.environment}-${var.application}-attendance-api-asg"

  # Instances will be launched in all matched backend/private subnets.
  vpc_zone_identifier = data.aws_subnets.backend_subnets.ids

  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size

  # Register ASG instances with the existing Attendance target group.
  target_group_arns = [
    data.aws_lb_target_group.attendance_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.attendance_api.id
    version = tostring(aws_launch_template.attendance_api.latest_version)
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.application}-attendance-api-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    precondition {
      condition     = length(data.aws_subnets.backend_subnets.ids) > 0
      error_message = "No backend subnets found in the VPC with Tier=backend tag."
    }

    precondition {
      condition = (
        var.asg_min_size <= var.asg_desired_capacity &&
        var.asg_desired_capacity <= var.asg_max_size
      )

      error_message = "Desired capacity must be between the minimum and maximum ASG sizes."
    }
  }
}
