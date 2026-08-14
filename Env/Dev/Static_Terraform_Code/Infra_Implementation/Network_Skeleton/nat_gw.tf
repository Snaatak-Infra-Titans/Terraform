resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}_${var.application}_nat_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  
  # Connects directly to Pawan's first public subnet
  subnet_id     = aws_subnet.public["a"].id

  tags = {
    Name = "${var.environment}_${var.application}_nat_gw"
  }

  # Explicit dependency to ensure IGW is fully attached to the VPC first
  depends_on = [aws_internet_gateway.main_igw]
}

# Mukesh's injection into Bhawna's private route table
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
