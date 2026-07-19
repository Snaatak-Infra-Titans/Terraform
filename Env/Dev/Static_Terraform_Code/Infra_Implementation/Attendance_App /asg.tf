data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-vpc" }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-private-subnet-*"]
  }
}

data "aws_security_group" "attendance" {
  tags = { Name = "${var.environment}-attendance-sg" }
}

data "aws_lb_target_group" "attendance" {
  name = "${var.environment}-attendance-tg"
}

# Launch Template
data "aws_launch_template" "attendance" {
  name = "${var.environment}-attendance"
}

# Auto Scaling Group
resource "aws_autoscaling_group" "attendance" {
  name                      = "${var.environment}-attendance-asg"
  vpc_zone_identifier       = data.aws_subnets.private.ids
  target_group_arns         = [data.aws_lb_target_group.attendance.arn]
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = data.aws_launch_template.attendance.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-attendance-asg"
    propagate_at_launch = true
  }
}

output "autoscaling_group_id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.attendance.id
}

output "autoscaling_group_arn" {
  description = "The ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.attendance.arn
}

