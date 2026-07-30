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

resource "aws_instance" "scylladb" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.database_subnet.id

  vpc_security_group_ids = [
    aws_security_group.scylla_sg.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.ssm.name

  key_name = data.aws_key_pair.existing_key.key_name

  associate_public_ip_address = false

  root_block_device {

    volume_size = 15

    volume_type = "gp3"

    encrypted = true

    delete_on_termination = true
  }

  tags = {

    Name = "${var.environment}-${var.application}-scylla-ec2"

    Application = "otms"

    Environment = var.environment

    Owner = var.owner

    CostCenter = var.cost_center
  }

}

resource "aws_security_group" "scylla_sg" {

  name        = "${var.environment}-${var.application}-scylla-sg"
  description = "Security Group for ScyllaDB EC2"

  vpc_id = data.aws_vpc.network_vpc.id

  tags = {
    Name        = "${var.environment}-${var.application}-scylla-sg"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

# Ingress Rule

resource "aws_vpc_security_group_ingress_rule" "scylla_cql" {

  security_group_id = aws_security_group.scylla_sg.id

  description = "Allow ScyllaDB CQL traffic from OTMS applications"

  from_port = 9042
  to_port   = 9042

  ip_protocol = "tcp"

  cidr_ipv4 = data.aws_vpc.network_vpc.cidr_block
}

# Egress Rule

resource "aws_vpc_security_group_egress_rule" "all_outbound" {

  security_group_id = aws_security_group.scylla_sg.id

  description = "Allow all outbound traffic"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
