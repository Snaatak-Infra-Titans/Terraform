
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name        = var.igw_name
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    Application = var.application
  }
}
