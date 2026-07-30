
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

  tags = merge(
    var.common_tags,
    {
      Name = "dev-otms-employee-api-sg"
    }
  )
}


resource "aws_instance" "employee_api" {
  ami                  = var.ami_id
  instance_type        = "t3.micro"
  
  subnet_id              = data.aws_subnet.backend.id
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  
  iam_instance_profile = var.iam_profile_name
  key_name             = var.key_pair_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "dev-otms-employee-api"
    }
  )
}
