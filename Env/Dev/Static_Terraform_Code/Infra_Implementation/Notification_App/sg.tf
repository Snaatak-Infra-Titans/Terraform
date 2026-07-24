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
