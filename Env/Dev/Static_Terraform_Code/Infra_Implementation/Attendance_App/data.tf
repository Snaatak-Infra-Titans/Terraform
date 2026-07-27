data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-terraform-state-dev-788572613316"
    key    = "network/vpc.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "subnets" {
  backend = "s3"

  config = {
    bucket = "otms-terraform-state-dev-788572613316"
    key    = "network/subnets.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "otms-terraform-state-dev-788572613316"
    key    = "network/alb.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ssh" {
  backend = "s3"

  config = {
    bucket = "otms-terraform-state-dev-788572613316"
    key    = "network/ssh.tfstate"
    region = "us-east-1"
  }
}

data "aws_lb_target_group" "attendance" {
  name = "dev-otms-attendance-tg"
}

data "aws_security_group" "alb" {
  filter {
    name   = "tag:Name"
    values = ["dev-otms-alb-sg"]
  }

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnets" "backend" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }

  filter {
    name = "tag:Name"
    values = [
      "dev_otms_backend_subnet_a",
      "dev_otms_backend_subnet_b"
    ]
  }
}
