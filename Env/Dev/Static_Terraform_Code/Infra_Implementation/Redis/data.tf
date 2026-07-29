data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "database_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.database_subnet_name]
  }
}

###############################################################################
# Existing Security Groups
###############################################################################

data "aws_security_group" "attendance_sg" {
  filter {
    name   = "group-name"
    values = ["dev-otms-attendance-sg"]
  }

  vpc_id = data.aws_vpc.network_vpc.id
}

data "aws_security_group" "salary_sg" {
  filter {
    name   = "group-name"
    values = ["dev-otms-salary-sg"]
  }

  vpc_id = data.aws_vpc.network_vpc.id
}

data "aws_security_group" "employee_sg" {
  filter {
    name   = "group-name"
    values = ["dev-otms-employee-sg"]
  }

  vpc_id = data.aws_vpc.network_vpc.id
}

###############################################################################
# Key Pair
###############################################################################

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

