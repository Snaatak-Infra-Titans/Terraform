resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  # Deploy into the first private frontend subnet
  subnet_id              = data.terraform_remote_state.network.outputs.frontend_subnet_ids[0]
  iam_instance_profile   = data.aws_iam_instance_profile.ssm_profile.name
  
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "dev-otms-frontend"
  }
}
