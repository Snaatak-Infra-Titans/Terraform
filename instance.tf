resource "aws_instance" "attendance_api" {
  ami           = var.ami_id
  instance_type = "t3.small"

  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.attendance_api_sg.id]

  iam_instance_profile = aws_iam_instance_profile.attendance_ssm_profile.name

  tags = {
    Name = "dev-attendance-api"
  }
}
