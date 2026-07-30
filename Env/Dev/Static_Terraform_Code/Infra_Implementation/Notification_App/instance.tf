resource "aws_instance" "notification" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.backend_subnet.id
  iam_instance_profile   = data.aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "dev-otms-notification-ec2"
  }
}
