resource "aws_instance" "frontend" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  
  
  subnet_id            = data.aws_subnet.frontend.id
  iam_instance_profile = data.aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = var.instance_name
  }
}
