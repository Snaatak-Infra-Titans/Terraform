resource "aws_autoscaling_group" "attendance_asg" {
  name = "${var.environment}-${var.application}-attendance-asg"

  # Fetch all backend/private subnet IDs from data.tf.
  vpc_zone_identifier = data.aws_subnets.backend_subnets.ids

  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size

  # Attach instances created by the ASG to the existing target group.
  target_group_arns = [
    data.aws_lb_target_group.attendance_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id = aws_launch_template.attendance_lt.id

    # Use the latest version created by Terraform.
    version = tostring(aws_launch_template.attendance_lt.latest_version)
  }

  lifecycle {
    precondition {
      condition     = length(data.aws_subnets.backend_subnets.ids) > 0
      error_message = "No backend subnets found with the Tier=backend tag."
    }

    precondition {
      condition = (
        var.asg_min_size <= var.asg_desired_capacity &&
        var.asg_desired_capacity <= var.asg_max_size
      )

      error_message = "ASG desired capacity must be between minimum and maximum capacity."
    }
  }
}
