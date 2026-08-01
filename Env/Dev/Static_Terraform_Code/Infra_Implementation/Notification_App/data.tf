# Lookup Subnet
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

# Lookup IAM Instance Profile
data "aws_iam_instance_profile" "selected" {
  name = var.iam_instance_profile
}
