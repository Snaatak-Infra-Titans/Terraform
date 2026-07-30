# Public Subnet
data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }
}

# Internet Gateway
data "aws_internet_gateway" "igw" {
  filter {
    name   = "tag:Name"
    values = [var.internet_gateway_name]
  }
}

# Private Route Table
data "aws_route_table" "private" {
  filter {
    name   = "tag:Name"
    values = [var.private_route_table_name]
  }
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = var.nat_eip_name
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.aws_subnet.public.id

  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = aws_nat_gateway.this.id
}
