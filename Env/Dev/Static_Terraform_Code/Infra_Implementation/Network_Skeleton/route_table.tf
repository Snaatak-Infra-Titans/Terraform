# Data lookups for VPC and Gateways
data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-vpc" }
}

data "aws_internet_gateway" "igw" {
  tags = { Name = "${var.environment}-igw" }
}

data "aws_nat_gateway" "nat" {
  tags = { Name = "${var.environment}-nat-gw" }
}

# Data lookups for Subnets
data "aws_subnet" "public_1" {
  tags = { Name = "${var.environment}-public-subnet-1" }
}

data "aws_subnet" "public_2" {
  tags = { Name = "${var.environment}-public-subnet-2" }
}

data "aws_subnet" "private_1" {
  tags = { Name = "${var.environment}-private-subnet-1" }
}

data "aws_subnet" "private_2" {
  tags = { Name = "${var.environment}-private-subnet-2" }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Application = var.tag_application
    Owner       = var.tag_owner
    Environment = var.environment
    CostCenter  = var.tag_costcenter
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${var.environment}-private-rt"
    Application = var.tag_application
    Owner       = var.tag_owner
    Environment = var.environment
    CostCenter  = var.tag_costcenter
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = data.aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = data.aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = data.aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = data.aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = data.aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id]
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}
