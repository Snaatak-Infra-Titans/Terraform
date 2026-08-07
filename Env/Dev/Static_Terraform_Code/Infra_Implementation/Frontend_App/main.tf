resource "aws_security_group" "frontend_sg" {
  name        = "dev-otms-frontend-sg"
  description = "Security Group for Frontend Application"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description     = "Allow web traffic from ALB on Port 3000"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.network.outputs.alb_security_group_id]
  }

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

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  # Deploy into the first private frontend subnet
  subnet_id            = data.terraform_remote_state.network.outputs.frontend_subnet_ids[0]
  iam_instance_profile = data.aws_iam_instance_profile.ssm_profile.name

  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  tags = {
    Name = "dev-otms-frontend"
  }
}
