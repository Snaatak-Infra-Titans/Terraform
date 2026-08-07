data "aws_vpc" "network_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_security_group" "salary_sg" {
  filter {
    name   = "tag:Name"
    values = ["dev-otms-salary-sg"]
  }
}

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

data "aws_ami" "salary_app" {
  most_recent = true
  owners      = [var.ami_owner_id]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "aws_iam_instance_profile" "ssm_profile" {
  name = var.ssm_instance_profile
}
