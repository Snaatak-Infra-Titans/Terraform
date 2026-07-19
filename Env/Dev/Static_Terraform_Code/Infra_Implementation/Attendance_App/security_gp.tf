data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-vpc" }
}

locals {
  ingress_rules = [
    { port = 8080, cidr = [data.aws_vpc.main.cidr_block] },
    { port = 22,   cidr = ["0.0.0.0/0"] }
  ]
}

# Attendance Service Security Group
resource "aws_security_group" "attendance" {
  name   = "${var.environment}-attendance-sg"
  vpc_id = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-attendance-sg"
    Application = var.tag_application
    Owner       = var.tag_owner
    Environment = var.environment
    CostCenter  = var.tag_costcenter
  }
}

output "attendance_security_group_id" {
  description = "The ID of the Attendance security group"
  value       = aws_security_group.attendance.id
}
