# Fetch existing OTMS VPC using the Name tag
data "aws_vpc" "otms" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Fetch one existing private/backend subnet
data "aws_subnet" "attendance" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.otms.id]
  }
}

# Fetch the existing Attendance API security group
data "aws_security_group" "attendance_api" {
  filter {
    name   = "tag:Name"
    values = [var.attendance_security_group_name]
  }

  vpc_id = data.aws_vpc.otms.id
}

# Fetch the existing IAM instance profile used for SSM
data "aws_iam_instance_profile" "attendance_ssm" {
  name = var.ssm_instance_profile_name
}
