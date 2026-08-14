
data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


data "aws_subnet" "backend" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}


data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = [var.alb_sg_name]
  }
  vpc_id = data.aws_vpc.main_vpc.id
}


data "aws_route53_zone" "private" {
  name         = "otms.internal"
  private_zone = true
}
