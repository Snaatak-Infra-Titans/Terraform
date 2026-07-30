locals {
  asg_tags = {
    Name        = "${var.environment}-${var.application}-notification"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnets" "backend_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  tags = {
    Tier = "backend"
  }
}

data "aws_lb" "existing_alb" {
  name = "${var.environment}-${var.application}-alb"
}

data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.existing_alb.arn
  port              = 443
}

data "aws_lb_listener_rule" "notification_routing" {
  listener_arn = data.aws_lb_listener.app_listener.arn
  priority     = 40
}

data "aws_lb_target_group" "notification_tg" {
  name = "${var.environment}-${var.application}-notification-tg"
}

data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["*alb*"]
  }
}

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

data "aws_ami" "notification_app" {
  most_recent = true
  owners      = [var.ami_owner_id]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

resource "aws_security_group" "notification_sg" {
  name        = "${var.environment}-${var.application}-notification-sg"
  description = "Security group for notification backend instances"
  vpc_id      = data.aws_vpc.network_vpc.id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 8085
    to_port         = 8085
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.application}-notification-sg"
  }
}

resource "aws_security_group" "packer_builder_sg" {
  name        = "${var.environment}-${var.application}-packer-builder-sg"
  description = "Security Group for Packer Builder Instance"
  vpc_id      = data.aws_vpc.network_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.application}-packer-builder-sg"
    Environment = var.environment
    Application = var.application
    Purpose     = "packer-builder"
  }
}

resource "aws_launch_template" "notification_lt" {
  name          = "${var.environment}-${var.application}-notification-lt"
  image_id      = data.aws_ami.notification_app.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.existing_key.key_name

  vpc_security_group_ids = [
    aws_security_group.notification_sg.id
  ]

  iam_instance_profile {
    name = var.ssm_instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-${var.application}-notification"
      Environment = var.environment
      Application = var.application
      Owner       = var.owner
      CostCenter  = var.cost_center
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "notification_asg" {
  name                = "${var.environment}-${var.application}-notification-asg"
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = data.aws_subnets.backend_subnets.ids

  target_group_arns = [
    data.aws_lb_target_group.notification_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.notification_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  dynamic "tag" {
    for_each = local.asg_tags

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

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.environment}-${var.application}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.notification_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.cpu_target_value
  }
}
