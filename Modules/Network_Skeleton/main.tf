############################################
# VPC
############################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

############################################
# Subnets
############################################

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id = aws_vpc.this.id

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    local.common_tags,
    each.value.additional_tags,
    {
      Name = "${local.name_prefix}-${each.key}"
    }
  )
}

############################################
# Internet Gateway
############################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

############################################
# NAT Gateway Elastic IP
############################################

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip"
    }
  )
}

############################################
# NAT Gateway
############################################

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id

  subnet_id = aws_subnet.this[
    var.nat_gateway_subnet_key
  ].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-gw"
    }
  )
}

############################################
# Public Route Table
############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-route-table"
    }
  )
}

############################################
# Public Internet Route
############################################

resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.this.id
}

############################################
# Private Route Table
############################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-route-table"
    }
  )
}

############################################
# Private NAT Route
############################################

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id = aws_route_table.private.id

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.this[0].id
}

############################################
# Public Route Table Associations
############################################

resource "aws_route_table_association" "public" {
  for_each = {
    for key, subnet in var.subnets :
    key => subnet
    if subnet.route_table_type == "public"
  }

  subnet_id = aws_subnet.this[each.key].id

  route_table_id = aws_route_table.public.id
}

############################################
# Private Route Table Associations
############################################

resource "aws_route_table_association" "private" {
  for_each = {
    for key, subnet in var.subnets :
    key => subnet
    if subnet.route_table_type == "private"
  }

  subnet_id = aws_subnet.this[each.key].id

  route_table_id = aws_route_table.private.id
}

############################################
# Security Groups
############################################

resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = "${local.name_prefix}-${each.key}-sg"
  description = each.value.description
  vpc_id      = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    each.value.additional_tags,
    {
      Name = "${local.name_prefix}-${each.key}-sg"
    }
  )
}

############################################
# Security Group Ingress Rules
############################################

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.security_group_ingress_rules

  security_group_id = aws_security_group.this[
    each.value.security_group_key
  ].id

  description = each.value.rule.description

  ip_protocol = each.value.rule.protocol

  from_port = each.value.rule.from_port
  to_port   = each.value.rule.to_port

  cidr_ipv4 = each.value.rule.cidr_ipv4

  referenced_security_group_id = (
    each.value.rule.source_security_group_key != null
    ? aws_security_group.this[
      each.value.rule.source_security_group_key
    ].id
    : null
  )

  tags = local.common_tags
}

############################################
# Security Group Egress Rules
############################################

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.security_group_egress_rules

  security_group_id = aws_security_group.this[
    each.value.security_group_key
  ].id

  description = each.value.rule.description

  ip_protocol = each.value.rule.protocol

  from_port = each.value.rule.from_port
  to_port   = each.value.rule.to_port

  cidr_ipv4 = each.value.rule.cidr_ipv4

  referenced_security_group_id = (
    each.value.rule.source_security_group_key != null
    ? aws_security_group.this[
      each.value.rule.source_security_group_key
    ].id
    : null
  )

  tags = local.common_tags
}

############################################
# Network ACLs
############################################

resource "aws_network_acl" "this" {
  for_each = var.network_acls

  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      rule_no = ingress.value.rule_number

      protocol = ingress.value.protocol
      action   = ingress.value.rule_action

      cidr_block = ingress.value.cidr_block

      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = each.value.egress

    content {
      rule_no = egress.value.rule_number

      protocol = egress.value.protocol
      action   = egress.value.rule_action

      cidr_block = egress.value.cidr_block

      from_port = egress.value.from_port
      to_port   = egress.value.to_port
    }
  }

  tags = merge(
    local.common_tags,
    each.value.additional_tags,
    {
      Name = "${local.name_prefix}-${each.key}-nacl"
    }
  )
}

############################################
# NACL Subnet Associations
############################################

resource "aws_network_acl_association" "this" {
  for_each = local.nacl_associations

  subnet_id = aws_subnet.this[
    each.value.subnet_key
  ].id

  network_acl_id = aws_network_acl.this[
    each.value.nacl_key
  ].id
}

############################################
# Application Load Balancer
############################################

resource "aws_lb" "this" {
  count = var.enable_alb ? 1 : 0

  name = "${local.name_prefix}-alb"

  internal           = var.alb_internal
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.this[var.alb_security_group_key].id
  ]

  subnets = [
    for subnet_key in var.alb_subnet_keys :
    aws_subnet.this[subnet_key].id
  ]

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb"
    }
  )
}

############################################
# HTTP Listener
############################################

resource "aws_lb_listener" "http" {
  count = var.enable_alb ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn

  port     = var.http_listener_port
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = tostring(var.https_listener_port)
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

############################################
# HTTPS Listener
############################################

resource "aws_lb_listener" "https" {
  count = var.enable_alb ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn

  port     = var.https_listener_port
  protocol = "HTTPS"

  certificate_arn = var.certificate_arn
  ssl_policy      = var.ssl_policy

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Route not found"
      status_code  = "404"
    }
  }
}

############################################
# Public Route53 Alias Records
############################################

resource "aws_route53_record" "public_alb_alias" {
  for_each = (
    var.enable_public_route53 && var.enable_alb
    ? var.public_route53_records
    : toset([])
  )

  zone_id = var.public_route53_zone_id

  name = each.value
  type = "A"

  alias {
    name                   = aws_lb.this[0].dns_name
    zone_id                = aws_lb.this[0].zone_id
    evaluate_target_health = true
  }
}

############################################
# Private Hosted Zone VPC Association
############################################

resource "aws_route53_zone_association" "private" {
  count = var.enable_private_route53 ? 1 : 0

  zone_id = var.private_route53_zone_id
  vpc_id  = aws_vpc.this.id
}

############################################
# Private Route53 Records
############################################

resource "aws_route53_record" "private" {
  for_each = (
    var.enable_private_route53
    ? var.private_dns_records
    : {}
  )

  zone_id = var.private_route53_zone_id

  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records

  depends_on = [
    aws_route53_zone_association.private
  ]
}
