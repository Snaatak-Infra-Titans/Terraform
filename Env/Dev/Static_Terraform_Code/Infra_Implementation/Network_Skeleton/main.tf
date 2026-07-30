data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = var.eip_name
    }
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.aws_subnet.public.id

  tags = merge(
    var.tags,
    {
      Name = var.nat_gateway_name
    }
  )
}

resource "aws_route" "private_nat" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = aws_nat_gateway.this.id
}
