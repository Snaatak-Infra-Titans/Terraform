
resource "aws_security_group" "frontend_sg" {
  name        = "dev-otms-frontend-sg"
  description = "Security Group for Frontend Application"
  vpc_id      = data.aws_vpc.main_vpc.id

  ingress {
    description     = "Allow web traffic from ALB on Port 3000"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_sg.id]  }

  egress {
    description = "Allow all outbound traffic for SSM and NAT access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-otms-frontend-sg"
  }
}


resource "aws_launch_template" "frontend" {
  name                   = "dev-otms-frontend-lt"
  image_id               = var.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  iam_instance_profile {
    name = data.aws_iam_instance_profile.ssm_profile.name
  }


  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "dev-otms-frontend"
    })
  }

 
  tag_specifications {
    resource_type = "volume"
    tags = merge(var.common_tags, {
      Name = "dev-otms-frontend-vol"
    })
  }

  tags = {
    Name = "dev-otms-frontend-lt"
  }
}


resource "aws_autoscaling_group" "frontend_asg" {
  name                = "dev-otms-frontend-asg"
  vpc_zone_identifier = data.aws_subnets.frontend.ids

  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  target_group_arns = [data.aws_lb_target_group.frontend_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  
  dynamic "tag" {
    for_each = merge(var.common_tags, { Name = "dev-otms-frontend" })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}


resource "aws_autoscaling_policy" "frontend_cpu_policy" {
  name                   = "dev-otms-frontend-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
