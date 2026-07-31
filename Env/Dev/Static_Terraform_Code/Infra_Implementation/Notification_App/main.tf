# ============================================================
# Data Sources - Existing Network Infrastructure
# ============================================================

# Fetch existing VPC from Network Skeleton
data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Fetch existing backend subnets
data "aws_subnets" "backend_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  tags = {
    Tier = "backend"
  }
}

# Fetch existing ALB from Network Skeleton
data "aws_lb" "existing_alb" {
  name = "${var.environment}-${var.application}-alb"
}

# Fetch HTTPS Listener (Port 443) from existing ALB
data "aws_lb_listener" "app_listener" {
  load_balancer_arn = data.aws_lb.existing_alb.arn
  port              = 443
}

# Fetch existing ALB Security Group
data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["*alb*"]
  }
}

/*
# Fetch existing Bastion Security Group
data "aws_security_group" "bastion_sg" {
  filter {
    name   = "tag:Name"
    values = ["*bastion*"]
  }
}
*/

# Fetch existing EC2 Key Pair
data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}


# ============================================================
# Notification Application Security Group
# ============================================================

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

  /*
  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [data.aws_security_group.bastion_sg.id]
  }
  */

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


# ============================================================
# Packer Builder Security Group
# ============================================================

resource "aws_security_group" "packer_builder_sg" {
  name        = "${var.environment}-${var.application}-packer-builder-sg"
  description = "Security group for temporary Packer builder instance"
  vpc_id      = data.aws_vpc.network_vpc.id

  ingress {
    description = "Allow SSH for Packer provisioning"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.application}-packer-builder-sg"
    Purpose     = "packer-builder"
    Application = var.application
    Environment = var.environment
  }
}
