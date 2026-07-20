############################################
# Existing VPC
############################################

data "aws_vpc" "selected_by_id" {
  count = var.vpc_id != "" ? 1 : 0
  id    = var.vpc_id
}

data "aws_vpc" "selected_by_name" {
  count = var.vpc_id == "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

locals {
  selected_vpc = var.vpc_id != "" ? data.aws_vpc.selected_by_id[0] : data.aws_vpc.selected_by_name[0]
}

############################################
# Existing Subnets
############################################

data "aws_subnets" "public" {

  filter {
    name   = "vpc-id"
    values = [local.selected_vpc.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnets" "frontend" {

  filter {
    name   = "vpc-id"
    values = [local.selected_vpc.id]
  }

  tags = {
    Tier = "frontend"
  }
}

data "aws_subnets" "backend" {

  filter {
    name   = "vpc-id"
    values = [local.selected_vpc.id]
  }

  tags = {
    Tier = "backend"
  }
}

data "aws_subnets" "database" {

  filter {
    name   = "vpc-id"
    values = [local.selected_vpc.id]
  }

  tags = {
    Tier = "database"
  }
}

############################################
# NACLs
############################################

resource "aws_network_acl" "public" {

  vpc_id = local.selected_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-public-nacl"
  }
}

resource "aws_network_acl" "frontend" {

  vpc_id = local.selected_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-frontend-nacl"
  }
}

resource "aws_network_acl" "backend" {

  vpc_id = local.selected_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-backend-nacl"
  }
}

resource "aws_network_acl" "database" {

  vpc_id = local.selected_vpc.id

  tags = {
    Name = "${var.environment}-${var.application}-database-nacl"
  }
}

############################################
# Public
############################################

resource "aws_network_acl_association" "public" {

  for_each = toset(data.aws_subnets.public.ids)

  subnet_id      = each.value
  network_acl_id = aws_network_acl.public.id
}

############################################
# Frontend
############################################

resource "aws_network_acl_association" "frontend" {

  for_each = toset(data.aws_subnets.frontend.ids)

  subnet_id      = each.value
  network_acl_id = aws_network_acl.frontend.id
}

############################################
# Backend
############################################

resource "aws_network_acl_association" "backend" {

  for_each = toset(data.aws_subnets.backend.ids)

  subnet_id      = each.value
  network_acl_id = aws_network_acl.backend.id
}

############################################
# Database
############################################

resource "aws_network_acl_association" "database" {

  for_each = toset(data.aws_subnets.database.ids)

  subnet_id      = each.value
  network_acl_id = aws_network_acl.database.id
}


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
