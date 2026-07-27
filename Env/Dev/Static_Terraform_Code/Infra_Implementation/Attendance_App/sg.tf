resource "aws_security_group" "attendance_sg" {
  name        = "${var.environment}-${var.application}-attendance-sg"
  description = "Security group for attendance backend instances"
  vpc_id      = data.aws_vpc.network_vpc.id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 8081
    to_port         = 8081
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
    Name = "${var.environment}-${var.application}-attendance-sg"
  }
}

