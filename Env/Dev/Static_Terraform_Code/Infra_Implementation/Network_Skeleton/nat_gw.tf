
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


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  
  # Links directly to Pawan's public subnet
  subnet_id     = aws_subnet.public["a"].id

  tags = {
    Name        = "${var.environment}_${var.application}_nat_gw"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

  # Explicit dependency on Deepak's IGW
  depends_on = [aws_internet_gateway.main_igw]
}


resource "aws_route" "private_nat_route" {
  # Links directly to Bhawna's private route table
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
