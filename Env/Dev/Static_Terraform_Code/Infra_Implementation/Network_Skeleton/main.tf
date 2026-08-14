resource "aws_internet_gateway" "main_igw" {
  vpc_id = data.aws_vpc.main_vpc.id

  tags = {
    Name = var.igw_name
  }
}
