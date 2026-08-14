
data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


data "aws_subnet" "frontend" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}


data "aws_iam_instance_profile" "ssm_profile" {
  name = var.iam_profile_name
}
