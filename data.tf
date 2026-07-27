data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["dev-otms-vpc"]
  }
}

data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["dev_otms_private_subnet_a"]
  }
}

data "aws_security_group" "attendance" {
  filter {
    name   = "group-name"
    values = ["dev-attendance-api-sg"]
  }
}

data "aws_iam_instance_profile" "attendance" {
  name = "attendance-ssm-profile"
}
