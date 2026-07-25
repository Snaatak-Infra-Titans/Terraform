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

data "aws_security_group" "scylla_sg" {
  name = "dev-otms-scylla-sg"
}

data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

data "aws_iam_instance_profile" "ssm" {
  name = "dev-otms-ssm-role"
}

data "aws_ami" "ubuntu" {

  most_recent = true

  owners = [var.ami_owner_id]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}
