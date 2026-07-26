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
