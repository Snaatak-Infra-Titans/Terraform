data "aws_subnet" "backend_subnet" {
  filter {
    name   = "tag:Name"
    values = ["dev-otms-backend-subnet-a"]
  }
}

data "aws_iam_instance_profile" "ssm_profile" {
  name = "dev-otms-ssm-role"
}
