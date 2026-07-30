

resource "aws_security_group" "api_sg" {
  name        = "dev-otms-employee-api-sg"
  description = "Security Group for the Employee API backend service"
  vpc_id      = data.aws_vpc.main_vpc.id

  ingress {
    description     = "Allow HTTP traffic from the ALB on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic to databases and internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "dev-otms-employee-api-sg"
  })
}


resource "aws_launch_template" "employee_api" {
  name_prefix   = "dev-otms-employee-api-lt-"
  description   = "Launch template for the Employee API backend"
  image_id      = var.ami_id
  instance_type = "t3.small"

  iam_instance_profile {
    name = "dev-otms-ssm-role"
  }

  key_name = var.key_pair_name

  network_interfaces {
    security_groups = [aws_security_group.api_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  # Propagate tags to instances
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "dev-otms-employee-api-asg-instance"
    })
  }

  # Propagate tags to EBS volumes
  tag_specifications {
    resource_type = "volume"
    tags = merge(var.common_tags, {
      Name = "dev-otms-employee-api-vol"
    })
  }

  tags = merge(var.common_tags, {
    Name = "dev-otms-employee-api-lt"
  })
}


resource "aws_autoscaling_group" "employee_api" {
  name                = "dev-otms-employee-api-asg"
  
  # Uses the dynamic list of backend subnet IDs fetched in data.tf
  vpc_zone_identifier = data.aws_subnets.backend.ids

  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  target_group_arns = [data.aws_lb_target_group.employee_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.employee_api.id
    version = "$Latest"
  }

  # Dynamically applies common tags and Name to both the ASG and its instances
  dynamic "tag" {
    for_each = merge(var.common_tags, { Name = "dev-otms-employee-api-asg-instance" })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}


resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "dev-otms-employee-api-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.employee_api.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
