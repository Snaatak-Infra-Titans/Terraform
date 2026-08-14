############################################
# Locals
############################################

locals {
  name_prefix = "${var.environment}-${var.application}"

  common_tags = merge(
    {
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
    },
    var.tags
  )
}

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

locals {
  security_group_ingress_rules = {
    for item in flatten([
      for sg_key, sg in var.security_groups : [
        for index, rule in sg.ingress : {
          key                = "${sg_key}-ingress-${index}"
          security_group_key = sg_key
          rule               = rule
        }
      ]
    ]) : item.key => item
  }

  security_group_egress_rules = {
    for item in flatten([
      for sg_key, sg in var.security_groups : [
        for index, rule in sg.egress : {
          key                = "${sg_key}-egress-${index}"
          security_group_key = sg_key
          rule               = rule
        }
      ]
    ]) : item.key => item
  }
}

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
}

############################################
# Network ACLs
############################################

resource "aws_network_acl" "this" {
  for_each = var.network_acls

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    each.value.additional_tags,
    {
      Name = "${local.name_prefix}-${each.key}-nacl"
    }
  )
}

############################################
# Flatten NACL Associations and Rules
############################################

locals {
  nacl_associations = {
    for item in flatten([
      for nacl_key, nacl in var.network_acls : [
        for subnet_key in nacl.subnet_keys : {
          key        = "${nacl_key}-${subnet_key}"
          nacl_key   = nacl_key
          subnet_key = subnet_key
        }
      ]
    ]) : item.key => item
  }

  nacl_ingress_rules = {
    for item in flatten([
      for nacl_key, nacl in var.network_acls : [
        for index, rule in nacl.ingress : {
          key      = "${nacl_key}-ingress-${index}"
          nacl_key = nacl_key
          rule     = rule
        }
      ]
    ]) : item.key => item
  }

  nacl_egress_rules = {
    for item in flatten([
      for nacl_key, nacl in var.network_acls : [
        for index, rule in nacl.egress : {
          key      = "${nacl_key}-egress-${index}"
          nacl_key = nacl_key
          rule     = rule
        }
      ]
    ]) : item.key => item
  }
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
# NACL Ingress Rules
############################################

resource "aws_network_acl_rule" "ingress" {
  for_each = local.nacl_ingress_rules

  network_acl_id = aws_network_acl.this[
    each.value.nacl_key
  ].id

  rule_number = each.value.rule.rule_number
  egress      = false

  protocol    = each.value.rule.protocol
  rule_action = each.value.rule.rule_action
  cidr_block  = each.value.rule.cidr_block

  from_port = each.value.rule.from_port
  to_port   = each.value.rule.to_port
}

############################################
# NACL Egress Rules
############################################

resource "aws_network_acl_rule" "egress" {
  for_each = local.nacl_egress_rules

  network_acl_id = aws_network_acl.this[
    each.value.nacl_key
  ].id

  rule_number = each.value.rule.rule_number
  egress      = true

  protocol    = each.value.rule.protocol
  rule_action = each.value.rule.rule_action
  cidr_block  = each.value.rule.cidr_block

  from_port = each.value.rule.from_port
  to_port   = each.value.rule.to_port
}
