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

  vpc_id = aws_vpc.this.id

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

  ##########################################
  # Dynamic Ingress Rules
  ##########################################

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

  ##########################################
  # Dynamic Egress Rules
  ##########################################

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
