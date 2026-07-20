# -----------------------------------------------------------
# Elastic IP for NAT Gateway
# -----------------------------------------------------------
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

# -----------------------------------------------------------
# NAT Gateway
# -----------------------------------------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id

  # Place NAT Gateway in one Public Subnet
  subnet_id = data.aws_subnets.public.ids[0]

  tags = {
    Name        = "${var.environment}_${var.application}_nat_gw"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

  depends_on = [
    data.aws_internet_gateway.existing_igw
  ]
}

# -----------------------------------------------------------
# Private Route
# -----------------------------------------------------------
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.nat.id
}
