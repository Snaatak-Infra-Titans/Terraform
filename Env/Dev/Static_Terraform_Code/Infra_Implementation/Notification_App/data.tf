data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
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

# Fetching the existing ALB from Network Skeleton
data "aws_lb" "existing_alb" {
  name = "${var.environment}-${var.application}-alb"
}

# Fetching the HTTPS Listener (Port 443) for routing rules
data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.existing_alb.arn
  port              = 443
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

data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["*alb*"]
  }
}

/*
data "aws_security_group" "bastion_sg" {
  filter {
    name   = "tag:Name"
    values = ["*bastion*"]
  }
}
*/
