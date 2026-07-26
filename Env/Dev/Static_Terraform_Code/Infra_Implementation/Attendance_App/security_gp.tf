data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-otms-vpc" }
}

# Attendance Service Security Group
resource "aws_security_group" "attendance" {
  name   = "${var.environment}-otms-attendance-sg"
  vpc_id = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [for c in ingress.value.cidr : c == "vpc" ? data.aws_vpc.main.cidr_block : c]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-otms-attendance-sg"
    Application = var.application
    Owner       = var.owner
    Environment = var.environment
    CostCenter  = var.cost_center
  }
}

