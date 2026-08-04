data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner_id]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "aws_iam_instance_profile" "ssm" {
  name = var.ssm_instance_profile_name
}
