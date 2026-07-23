
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = data.aws_vpc.existing.id

  tags = {
    Name = var.igw_name
  }
}
