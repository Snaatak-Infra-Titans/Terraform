resource "aws_launch_template" "frontend" {
  name                  = "dev-otms-frontend-lt"
  image_id              = var.ami_id
  instance_type         = "t3.micro"
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

 
  iam_instance_profile {
    name = data.aws_iam_instance_profile.ssm_profile.name
  }

  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "dev-otms-frontend"
    }
  }

  tags = {
    Name = "dev-otms-frontend-lt"
  }
}
