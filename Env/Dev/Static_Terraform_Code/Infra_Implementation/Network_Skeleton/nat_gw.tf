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
  
  # Link directly to the FIRST public subnet Pawan created (index "a")
  subnet_id     = aws_subnet.public["a"].id

  tags = {
    Name        = "${var.environment}_${var.application}_nat_gw"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

  # EXPLICIT DEPENDENCY: NAT Gateway requires an IGW to exist in the VPC first!
  depends_on = [aws_internet_gateway.main_igw]
}

# -----------------------------------------------------------
# Route: Point Private Traffic to the NAT Gateway
# -----------------------------------------------------------
resource "aws_route" "private_nat_route" {
  # Link directly to Bhawna's private route table
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
