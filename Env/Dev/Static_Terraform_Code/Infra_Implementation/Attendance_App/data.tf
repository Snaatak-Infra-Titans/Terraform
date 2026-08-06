# Fetch existing VPC using its Name tag.
data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Fetch backend/private subnets from the selected VPC.
data "aws_subnets" "backend_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["backend"]
  }
}

# Fetch public subnets from the selected VPC.
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}

# Fetch existing ALB.
data "aws_lb" "existing_alb" {
  name = "${var.environment}-${var.application}-alb"
}

# Fetch HTTPS listener from the existing ALB.
data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.existing_alb.arn
  port              = 443
}

# Fetch existing EC2 key pair.
data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

# Fetch existing Attendance API AMI.
data "aws_ami" "attendance_app" {
  owners = ["self"]

  filter {
    name   = "image-id"
    values = [var.ami_id]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Fetch existing Attendance API target group.
data "aws_lb_target_group" "attendance_tg" {
  name = "${var.environment}-${var.application}-attendance-tg"
}

# Fetch existing IAM instance profile.
data "aws_iam_instance_profile" "attendance_ssm" {
  name = var.ssm_instance_profile
}
