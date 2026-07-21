############################################
# NACLs (Linked directly to Saransh's VPC)
############################################

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-public-nacl"
  }
}

resource "aws_network_acl" "frontend" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-frontend-nacl"
  }
}

resource "aws_network_acl" "backend" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-backend-nacl"
  }
}

resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-database-nacl"
  }
}

############################################
# Associations (Looping directly over Pawan's Subnets)
############################################

resource "aws_network_acl_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.public.id
}

resource "aws_network_acl_association" "frontend" {
  for_each       = aws_subnet.frontend
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.frontend.id
}

resource "aws_network_acl_association" "backend" {
  for_each       = aws_subnet.backend
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.backend.id
}

resource "aws_network_acl_association" "database" {
  for_each       = aws_subnet.database
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.database.id
}

############################################
# Public Rules
############################################
# Inbound

resource "aws_network_acl_rule" "public_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_frontend_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.32/28"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_backend_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 1024
  to_port        = 65535
}

# Outbound

resource "aws_network_acl_rule" "public_to_frontend" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.32/28"
  from_port      = 3000
  to_port        = 3000
}

resource "aws_network_acl_rule" "public_to_employee" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 8080
  to_port        = 8080
}

resource "aws_network_acl_rule" "public_to_attendance" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 8081
  to_port        = 8081
}

resource "aws_network_acl_rule" "public_to_salary" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 8082
  to_port        = 8082
}

resource "aws_network_acl_rule" "public_to_notification" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 140
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 8085
  to_port        = 8085
}

resource "aws_network_acl_rule" "public_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 150
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

############################################
# Frontend Rules
############################################
# Inbound

resource "aws_network_acl_rule" "frontend_alb" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 3000
  to_port        = 3000
}

resource "aws_network_acl_rule" "frontend_ephemeral" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "frontend_ssm" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Outbound

resource "aws_network_acl_rule" "frontend_return" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "frontend_https" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

############################################
# Backend Rules
############################################
# Inbound

resource "aws_network_acl_rule" "backend_employee" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 8080
  to_port        = 8080
}

resource "aws_network_acl_rule" "backend_attendance" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 8081
  to_port        = 8081
}

resource "aws_network_acl_rule" "backend_salary" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 8082
  to_port        = 8082
}

resource "aws_network_acl_rule" "backend_notification" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 8085
  to_port        = 8085
}

resource "aws_network_acl_rule" "backend_ephemeral" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 140
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "backend_ssm" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 150
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Outbound

resource "aws_network_acl_rule" "backend_redis" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.96/27"
  from_port      = 6379
  to_port        = 6379
}

resource "aws_network_acl_rule" "backend_postgres" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.96/27"
  from_port      = 5432
  to_port        = 5432
}

resource "aws_network_acl_rule" "backend_scylla" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 120
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.96/27"
  from_port      = 9042
  to_port        = 9042
}

resource "aws_network_acl_rule" "backend_return" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 130
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/27"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "backend_https" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 140
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

############################################
# DataBase Rules
############################################
# Inbound
resource "aws_network_acl_rule" "database_redis" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 6379
  to_port        = 6379
}

resource "aws_network_acl_rule" "database_postgres" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 5432
  to_port        = 5432
}

resource "aws_network_acl_rule" "database_scylla" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 9042
  to_port        = 9042
}

resource "aws_network_acl_rule" "database_ssm" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Outbound

resource "aws_network_acl_rule" "database_return" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "10.0.0.64/27"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "database_https" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}
