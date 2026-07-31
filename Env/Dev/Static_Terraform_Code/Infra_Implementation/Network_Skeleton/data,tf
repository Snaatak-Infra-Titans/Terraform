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
