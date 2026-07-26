# Lookup VPC
data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-otms-vpc" }
}

# Lookup Attendance App Security Group
data "aws_security_group" "attendance" {
  tags = { Name = "${var.environment}-otms-attendance-sg" }
}

# PostgreSQL Security Group
resource "aws_security_group" "postgresql" {
  name        = "${var.environment}-otms-postgres-sg"
  description = "Security group for PostgreSQL database"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description     = "Allow PostgreSQL access from Attendance app security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.aws_security_group.attendance.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-otms-postgres-sg"
    Application = var.tag_application
    Owner       = var.tag_owner
    Environment = var.environment
    CostCenter  = var.tag_costcenter
  }
}

