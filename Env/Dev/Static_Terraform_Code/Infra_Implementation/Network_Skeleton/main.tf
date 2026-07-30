##########################
# Existing Resources
##########################

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

##########################
# Internet Gateway
##########################

resource "aws_internet_gateway" "this" {
  vpc_id = data.aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-igw"
    }
  )
}

##########################
# Elastic IP
##########################

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-nat-eip"
    }
  )
}

##########################
# Public Route Table
##########################

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-public-rt"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = data.aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

##########################
# NAT Gateway
##########################

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.aws_subnet.public.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-nat-gateway"
    }
  )

  depends_on = [
    aws_internet_gateway.this
  ]
}

##########################
# Private Route Table
##########################

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.application}-private-rt"
    }
  )
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = data.aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
