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

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["*alb*"]
  }
}

data "aws_security_group" "bastion_sg" {
  filter {
    name   = "tag:Name"
    values = ["*bastion*"]
  }
}

data "aws_lb" "existing_alb" {
  # Apne actual Shared ALB ka naam yahan verify karke daalna
  name = "${var.environment}-shared-alb"
}

data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.existing_alb.arn
  port              = 80 # Agar HTTPS use kar rahe ho toh isko 443 kar dena
}
