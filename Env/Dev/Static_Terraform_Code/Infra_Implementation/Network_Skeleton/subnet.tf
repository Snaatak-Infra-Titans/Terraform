locals {
  subnet_plan = {
    public   = { offset = 0, public = true }
    frontend = { offset = 2, public = false }
    backend  = { offset = 4, public = false }
    database = { offset = 6, public = false }
  }
}

# --- SUBNET RESOURCES ---
resource "aws_subnet" "public" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, var.subnet_newbits, local.subnet_plan.public.offset + each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}_${var.application}_public_subnet_${each.key}"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Tier        = "public"
    AZ          = "${var.aws_region}${each.key}"
  }
}

resource "aws_subnet" "frontend" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, var.subnet_newbits, local.subnet_plan.frontend.offset + each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}_${var.application}_frontend_subnet_${each.key}"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Tier        = "frontend"
    AZ          = "${var.aws_region}${each.key}"
  }
}

resource "aws_subnet" "backend" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, var.subnet_newbits, local.subnet_plan.backend.offset + each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}_${var.application}_backend_subnet_${each.key}"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Tier        = "backend"
    AZ          = "${var.aws_region}${each.key}"
  }
}

resource "aws_subnet" "database" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, var.subnet_newbits, local.subnet_plan.database.offset + each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}_${var.application}_database_subnet_${each.key}"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Tier        = "database"
    AZ          = "${var.aws_region}${each.key}"
  }
}
