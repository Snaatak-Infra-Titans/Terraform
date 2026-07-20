# Prefer lookup by ID when provided because tag lookups can sometimes return multiple matches; both methods are supported by the provider. [web:2]
# If vpc_id is set, use that lookup; otherwise filter by tag:Name.
data "aws_vpc" "by_id" {
  count = var.vpc_id != "" ? 1 : 0
  id    = var.vpc_id
}

data "aws_vpc" "by_name" {
  count = var.vpc_id == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Expose a single unified local reference to the selected VPC
locals {
  selected_vpc = var.vpc_id != "" ? data.aws_vpc.by_id[0] : data.aws_vpc.by_name[0]
}
# The example creates four subnets within the existing VPC:
#  - public (map_public_ip_on_launch = true)
#  - frontend (private)
#  - backend (private)
#  - database (private)
# CIDR calculation uses cidrsubnet(prefix, newbits, netnum), see docs. [web:19]

resource "aws_subnet" "public" {
  vpc_id                  = local.selected_vpc.id
  cidr_block              = cidrsubnet(local.selected_vpc.cidr_block, var.subnet_newbits, 0)
  availability_zone       = "${var.aws_region}${var.az_suffix}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}_${var.application}_public_subnet"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_subnet" "frontend" {
  vpc_id                  = local.selected_vpc.id
  cidr_block              = cidrsubnet(local.selected_vpc.cidr_block, var.subnet_newbits, 1)
  availability_zone       = "${var.aws_region}${var.az_suffix}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}_${var.application}_frontend_subnet"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_subnet" "backend" {
  vpc_id                  = local.selected_vpc.id
  cidr_block              = cidrsubnet(local.selected_vpc.cidr_block, var.subnet_newbits, 2)
  availability_zone       = "${var.aws_region}${var.az_suffix}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}_${var.application}_backend_subnet"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_subnet" "database" {
  vpc_id                  = local.selected_vpc.id
  cidr_block              = cidrsubnet(local.selected_vpc.cidr_block, var.subnet_newbits, 3)
  availability_zone       = "${var.aws_region}${var.az_suffix}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}_${var.application}_database_subnet"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}
