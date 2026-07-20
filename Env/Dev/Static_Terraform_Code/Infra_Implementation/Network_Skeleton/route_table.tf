# -----------------------------------------------------------
# 1. DATA BLOCKS (Fetch existing VPC, IGW, and Subnets)
# -----------------------------------------------------------
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_internet_gateway" "existing_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

# Fetch Public Subnets
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}

# Fetch Frontend Subnets
data "aws_subnets" "frontend" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["frontend"]
  }
}

# Fetch Backend Subnets
data "aws_subnets" "backend" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["backend"]
  }
}

# Fetch Database Subnets
data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["database"]
  }
}

# -----------------------------------------------------------
# 2. PUBLIC ROUTE TABLE & ASSOCIATIONS
# -----------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name        = "${var.environment}_${var.application}_public_rt"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Tier        = "public"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.existing_igw.id
}

# Iterate over the fetched public subnet IDs
resource "aws_route_table_association" "public" {
  for_each       = toset(data.aws_subnets.public.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------
# 3. PRIVATE ROUTE TABLE & ASSOCIATIONS
# -----------------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name        = "${var.environment}_${var.application}_private_rt"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
    Tier        = "private"
  }
}

# Iterate over the fetched frontend subnet IDs
resource "aws_route_table_association" "frontend" {
  for_each       = toset(data.aws_subnets.frontend.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

# Iterate over the fetched backend subnet IDs
resource "aws_route_table_association" "backend" {
  for_each       = toset(data.aws_subnets.backend.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

# Iterate over the fetched database subnet IDs
resource "aws_route_table_association" "database" {
  for_each       = toset(data.aws_subnets.database.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}
