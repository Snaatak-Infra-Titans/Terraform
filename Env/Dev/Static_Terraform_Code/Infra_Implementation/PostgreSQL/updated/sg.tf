resource "aws_security_group" "postgresql" {
  name        = "${local.name_prefix}-postgresql-sg"
  description = "Security group for PostgreSQL EC2 instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-postgresql-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgresql" {
  security_group_id = aws_security_group.postgresql.id

  description = "Allow PostgreSQL traffic from OTMS applications"

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  cidr_ipv4 = var.postgresql_allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.postgresql.id

  description = "Allow outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
