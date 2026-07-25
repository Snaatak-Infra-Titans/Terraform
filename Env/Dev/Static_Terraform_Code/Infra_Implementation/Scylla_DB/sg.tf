resource "aws_security_group" "scylla_sg" {

  name        = "${var.environment}-${var.application}-scylla-sg"
  description = "Security Group for ScyllaDB EC2"

  vpc_id = data.aws_vpc.network_vpc.id

  tags = {
    Name        = "${var.environment}-${var.application}-scylla-sg"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

# Ingress Rule

resource "aws_vpc_security_group_ingress_rule" "scylla_cql" {

  security_group_id = aws_security_group.scylla_sg.id

  description = "Allow ScyllaDB CQL traffic from OTMS applications"

  from_port   = 9042
  to_port     = 9042

  ip_protocol = "tcp"

  cidr_ipv4 = data.aws_vpc.network_vpc.cidr_block
}

# Egress Rule

resource "aws_vpc_security_group_egress_rule" "all_outbound" {

  security_group_id = aws_security_group.scylla_sg.id

  description = "Allow all outbound traffic"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
