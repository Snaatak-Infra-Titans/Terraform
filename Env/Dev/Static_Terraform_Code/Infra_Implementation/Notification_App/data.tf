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

data "aws_lb_target_group" "notification_tg" {
  name = "${var.environment}-${var.application}-notification-tg"
}

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

data "aws_ami" "notification_app" {
  most_recent = true
  owners      = ["547941801997"] # Tumhari exact Account ID

  filter {
    name   = "name"
    values = ["notification-es-golden-v1"] # Golden AMI name
  }
}
