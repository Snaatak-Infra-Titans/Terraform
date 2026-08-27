locals {
  name_prefix = "${var.environment}-${var.application}"

  nat_eip_name     = "${local.name_prefix}-nat-eip"
  nat_gateway_name = "${local.name_prefix}-nat-gateway"
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = local.nat_eip_name
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = data.aws_subnet.public.id

  tags = merge(
    var.tags,
    {
      Name = local.nat_gateway_name
    }
  )
}
