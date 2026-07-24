
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  
  # Deploy into the first private frontend subnet
  subnet_id            = data.terraform_remote_state.network.outputs.frontend_subnet_ids[0]
  iam_instance_profile = data.aws_iam_instance_profile.ssm_profile.name

  # Only specify resource-specific tags here; default_tags handles the rest
  tags = {
    Name = "dev-otms-frontend-instance"
  }
}
