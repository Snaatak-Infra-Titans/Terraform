data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "database_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.database_subnet_name]
  }
}

###############################################################################
# Existing Security Groups
###############################################################################

data "aws_security_group" "attendance_sg" {
  filter {
    name   = "group-name"
    values = ["dev-otms-attendance-sg"]
  }

  vpc_id = data.aws_vpc.network_vpc.id
}

data "aws_security_group" "salary_sg" {
  filter {
    name   = "group-name"
    values = ["dev-otms-salary-sg"]
  }

  vpc_id = data.aws_vpc.network_vpc.id
}

data "aws_security_group" "employee_sg" {
  filter {
    name   = "group-name"
    values = ["dev-otms-employee-sg"]
  }

  vpc_id = data.aws_vpc.network_vpc.id
}

###############################################################################
# Key Pair
###############################################################################

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

###############################################################################
# AMI
###############################################################################

data "aws_ami" "salary_app" {
  most_recent = true
  owners      = [var.ami_owner_id]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

###############################################################################
# Redis Security Group
###############################################################################

resource "aws_security_group" "redis_sg" {
  name        = "${var.environment}-${var.application}-redis-sg"
  description = "Security Group for Redis EC2"
  vpc_id      = data.aws_vpc.network_vpc.id

  tags = {
    Name        = "${var.environment}-${var.application}-redis-sg"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

###############################################################################
# Ingress Rules
###############################################################################

resource "aws_vpc_security_group_ingress_rule" "salary_to_redis" {
  security_group_id            = aws_security_group.redis_sg.id
  referenced_security_group_id = data.aws_security_group.salary_sg.id

  description = "Allow Redis from Salary API"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "employee_to_redis" {
  security_group_id            = aws_security_group.redis_sg.id
  referenced_security_group_id = data.aws_security_group.employee_sg.id

  description = "Allow Redis from Employee API"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "attendance_to_redis" {
  security_group_id            = aws_security_group.redis_sg.id
  referenced_security_group_id = data.aws_security_group.attendance_sg.id

  description = "Allow Redis from Attendance API"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

###############################################################################
# Egress Rule
###############################################################################

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.redis_sg.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
