############################################
# NACLs
############################################
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "${var.environment}-${var.application}-public-nacl" }
}

resource "aws_network_acl" "frontend" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "${var.environment}-${var.application}-frontend-nacl" }
}

resource "aws_network_acl" "backend" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "${var.environment}-${var.application}-backend-nacl" }
}

resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "${var.environment}-${var.application}-database-nacl" }
}

############################################
# Associations
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
# Public NACL Rules
############################################
resource "aws_network_acl_rule" "public_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.http_port
  to_port        = var.http_port
}

resource "aws_network_acl_rule" "public_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.https_port
  to_port        = var.https_port
}

resource "aws_network_acl_rule" "public_frontend_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.frontend_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "public_backend_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "public_to_frontend" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.frontend_cidr
  from_port      = var.frontend_port
  to_port        = var.frontend_port
}

resource "aws_network_acl_rule" "public_to_employee" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.employee_port
  to_port        = var.employee_port
}

resource "aws_network_acl_rule" "public_to_attendance" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.attendance_port
  to_port        = var.attendance_port
}

resource "aws_network_acl_rule" "public_to_salary" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.salary_port
  to_port        = var.salary_port
}

resource "aws_network_acl_rule" "public_to_notification" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 140
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.notification_port
  to_port        = var.notification_port
}

resource "aws_network_acl_rule" "public_https_outbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 150
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.https_port
  to_port        = var.https_port
}

resource "aws_network_acl_rule" "public_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 160
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "public_packer_ssh_inbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 140
  egress         = false
  protocol       = "6"
  rule_action    = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 22
  to_port   = 22
}

############################################
# Frontend Rules
############################################
resource "aws_network_acl_rule" "frontend_alb" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.frontend_port
  to_port        = var.frontend_port
}

resource "aws_network_acl_rule" "frontend_ephemeral" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "frontend_https_inbound" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.https_port
  to_port        = var.https_port
}

resource "aws_network_acl_rule" "frontend_ephemeral_outbound" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "frontend_https_outbound" {
  network_acl_id = aws_network_acl.frontend.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.https_port
  to_port        = var.https_port
}

############################################
# Backend Rules
############################################
resource "aws_network_acl_rule" "backend_employee" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.employee_port
  to_port        = var.employee_port
}

resource "aws_network_acl_rule" "backend_attendance" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.attendance_port
  to_port        = var.attendance_port
}

resource "aws_network_acl_rule" "backend_salary" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.salary_port
  to_port        = var.salary_port
}

resource "aws_network_acl_rule" "backend_notification" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.notification_port
  to_port        = var.notification_port
}

resource "aws_network_acl_rule" "backend_ephemeral_inbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 140
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "backend_https_inbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 150
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.https_port
  to_port        = var.https_port
}

resource "aws_network_acl_rule" "backend_ephemeral_port_inbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 160
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "backend_redis" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.database_cidr
  from_port      = var.redis_port
  to_port        = var.redis_port
}

resource "aws_network_acl_rule" "backend_postgres" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.database_cidr
  from_port      = var.postgres_port
  to_port        = var.postgres_port
}

resource "aws_network_acl_rule" "backend_scylla" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 120
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.database_cidr
  from_port      = var.scylla_port
  to_port        = var.scylla_port
}

resource "aws_network_acl_rule" "backend_ephemeral_outbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 130
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.public_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "backend_https_outbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 140
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.https_port
  to_port        = var.https_port
}

resource "aws_network_acl_rule" "backend_ephemeral_any_inbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 150
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "backend_http_outbound" {
  network_acl_id = aws_network_acl.backend.id
  rule_number    = 160
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.http_port
  to_port        = var.http_port
}

############################################
# Database Rules
############################################
resource "aws_network_acl_rule" "database_redis" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.redis_port
  to_port        = var.redis_port
}

resource "aws_network_acl_rule" "database_postgres" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.postgres_port
  to_port        = var.postgres_port
}

resource "aws_network_acl_rule" "database_scylla" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.scylla_port
  to_port        = var.scylla_port
}

resource "aws_network_acl_rule" "database_ephemeral_inbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}

resource "aws_network_acl_rule" "database_redis_outbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.redis_port
  to_port        = var.redis_port
}

resource "aws_network_acl_rule" "database_postgres_outbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 110
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.postgres_port
  to_port        = var.postgres_port
}

resource "aws_network_acl_rule" "database_scylla_outbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 120
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.scylla_port
  to_port        = var.scylla_port
}

resource "aws_network_acl_rule" "database_ephemeral_outbound" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 130
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.backend_cidr
  from_port      = var.ephemeral_from_port
  to_port        = var.ephemeral_to_port
}
