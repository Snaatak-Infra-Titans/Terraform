# SSM Instance Profile
data "aws_iam_instance_profile" "ssm_profile" {
  name = "dev-otms-ssm-role"
}

# Backend Subnet
data "aws_subnet" "backend_subnet" {
  filter {
    name   = "tag:Name"
    values = ["dev_otms_backend_subnet_a"]
  }
}

resource "aws_instance" "notification" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.backend_subnet.id
  iam_instance_profile   = data.aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "dev-otms-notification-ec2"
  }
}
