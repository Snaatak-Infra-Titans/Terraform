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
