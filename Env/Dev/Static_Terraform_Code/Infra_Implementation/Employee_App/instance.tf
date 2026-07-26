resource "aws_instance" "employee_api" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  
  # Deploying into the first backend subnet fetched from the remote state
  subnet_id              = data.terraform_remote_state.network.outputs.backend_subnet_ids[0]
  
 
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  
  iam_instance_profile   = "dev-otms-ssm-role"
  key_name               = data.terraform_remote_state.network.outputs.key_pair_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "dev-otms-employee-api"
    }
  )
}
