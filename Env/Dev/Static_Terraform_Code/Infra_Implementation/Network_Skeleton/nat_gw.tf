
# Elastic IP for NAT Gateway

resource "aws_eip" "dev_otms_nat_eip" {

  domain = "vpc"

  tags = {
    Name        = "dev-otms-nat-eip"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

}

# NAT Gateway

resource "aws_nat_gateway" "dev_otms_nat_gw" {

  allocation_id     = aws_eip.dev_otms_nat_eip.id
  subnet_id         = aws_subnet.dev_otms_public_subnet_1.id
  connectivity_type = "public"

  depends_on = [
    aws_internet_gateway.dev_otms_igw
  ]

  tags = {
    Name        = "dev-otms-nat-gw"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

}

# Route for Private Route Table

resource "aws_route" "dev_otms_private_nat_route" {

  route_table_id         = aws_route_table.dev_otms_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.dev_otms_nat_gw.id

}