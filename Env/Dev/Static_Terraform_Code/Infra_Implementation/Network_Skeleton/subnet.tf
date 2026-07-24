# --- PUBLIC SUBNETS (10.0.0.0/27 & 10.0.0.32/27) ---
resource "aws_subnet" "public" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.public_cidr, 1, each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_${var.application}_public_subnet_${each.key}"
    Tier = "public"
    AZ   = "${var.aws_region}${each.key}"
  }
}

# --- FRONTEND SUBNETS (10.0.0.64/27 & 10.0.0.96/27) ---
resource "aws_subnet" "frontend" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.frontend_cidr, 1, each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}_${var.application}_frontend_subnet_${each.key}"
    Tier = "frontend"
    AZ   = "${var.aws_region}${each.key}"
  }
}

# --- BACKEND SUBNETS (10.0.0.128/27 & 10.0.0.160/27) ---
resource "aws_subnet" "backend" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.backend_cidr, 1, each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}_${var.application}_backend_subnet_${each.key}"
    Tier = "backend"
    AZ   = "${var.aws_region}${each.key}"
  }
}

# --- DATABASE SUBNETS (10.0.0.192/27 & 10.0.0.224/27) ---
resource "aws_subnet" "database" {
  for_each = { for idx, az in var.azs : az => { az_index = idx } }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.database_cidr, 1, each.value.az_index)
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}_${var.application}_database_subnet_${each.key}"
    Tier = "database"
    AZ   = "${var.aws_region}${each.key}"
  }
}
