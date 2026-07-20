# Existing VPC

data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Existing Internet Gateway

data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}


# Existing Public Subnets

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}


# Existing Private Route Table

data "aws_route_table" "private" {
  vpc_id = data.aws_vpc.existing.id

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}


# Elastic IP

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.environment}_${var.application}_nat_eip"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}


# NAT Gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = data.aws_subnets.public.ids[0]

  tags = {
    Name        = "${var.environment}_${var.application}_nat_gw"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

  depends_on = [data.aws_internet_gateway.existing]
}


# Default Route

resource "aws_route" "private_nat_route" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
