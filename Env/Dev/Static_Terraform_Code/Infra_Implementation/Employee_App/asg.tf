# Standard Tags Local Block (Acceptance Criteria 5)
locals {
  common_tags = {
    Application = var.application_name
    Owner       = var.owner
    Environment = var.environment
    CostCenter  = var.cost_center
  }
}

# Launch Template (Configured in Ticket 431)
resource "aws_launch_template" "employee_app" {
  name_prefix   = "${var.environment}-${var.application_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.environment}-${var.application_name}-instance"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group (Ticket 433 - Pawan)
resource "aws_autoscaling_group" "employee_app_asg" {
  name_prefix         = "${var.environment}-${var.application_name}-asg-"
  vpc_zone_identifier = var.vpc_zone_identifier

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  # Attached to Target Group created by Deepak in Ticket 432
  target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.employee_app.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  # Propagate standard tags to instances launched by ASG
  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
