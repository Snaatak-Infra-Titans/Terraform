resource "aws_security_group" "api_sg" {
  name        = "dev-otms-employee-api-sg"
  description = "Security Group for the Employee API backend service"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id


  ingress {
    description     = "Allow HTTP traffic from the ALB on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.network.outputs.alb_security_group_id]
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
