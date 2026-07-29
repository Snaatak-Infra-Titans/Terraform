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

# Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "redis" {
  security_group_id = aws_security_group.redis_sg.id
  description       = "Allow Redis traffic from Backend subnet"
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
  security_group_id = data.aws_security_group.salary_sg.id
}
/*
resource "aws_vpc_security_group_ingress_rule" "redis" {
  security_group_id = aws_security_group.redis_sg.id
  description       = "Allow Redis traffic from Backend subnet"
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
  security_group_id = data.aws_security_group.employee_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "redis" {
  security_group_id = aws_security_group.redis_sg.id
  description       = "Allow Redis traffic from Backend subnet"
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
  security_group_id = data.aws_security_group.attendance_sg.id
}
*/
# Egress Rule
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.redis_sg.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
