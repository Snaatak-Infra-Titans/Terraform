data "aws_vpc" "main_vpc" {
  tags = {
    Name = "${var.environment}-${var.application}-vpc"
  }
}

data "aws_internet_gateway" "main_igw" {
  tags = {
    Name = "${var.environment}-${var.application}-igw"
  }
}

data "aws_subnet" "public" {
  for_each = toset(["a", "b"])
  tags = {
    Name = "${var.environment}_${var.application}_public_subnet_${each.value}"
  }
}

data "aws_subnet" "frontend" {
  for_each = toset(["a", "b"])
  tags = {
    Name = "${var.environment}_${var.application}_frontend_subnet_${each.value}"
  }
}

data "aws_subnet" "backend" {
  for_each = toset(["a", "b"])
  tags = {
    Name = "${var.environment}_${var.application}_backend_subnet_${each.value}"
  }
}

data "aws_subnet" "database" {
  for_each = toset(["a", "b"])
  tags = {
    Name = "${var.environment}_${var.application}_database_subnet_${each.value}"
  }
}

# -----------------------------------------------------------
# 1. PUBLIC ROUTE TABLE & ASSOCIATIONS
# -----------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}_${var.application}_public_rt"
    Tier = "public"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public" {
  for_each       = data.aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------
# 2. PRIVATE ROUTE TABLE & ASSOCIATIONS
# -----------------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}_${var.application}_private_rt"
    Tier = "private"
  }
}

resource "aws_route_table_association" "frontend" {
  for_each       = data.aws_subnet.frontend
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "backend" {
  for_each       = data.aws_subnet.backend
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  for_each       = data.aws_subnet.database
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
