resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.aws_subnet.public.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-nat-gateway"
    }
  )
}
