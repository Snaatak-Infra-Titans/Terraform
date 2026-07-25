resource "aws_instance" "employee_api" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  
  # Deploying into the first backend subnet fetched from the remote state
  subnet_id              = data.terraform_remote_state.network.outputs.backend_subnet_ids[0]
  
  # Using the default SG fetched from data.tf
  vpc_security_group_ids = [data.aws_security_group.default.id]
  
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

resource "aws_route53_record" "api_dns" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = "api.otms.internal"
  type    = "A"
  ttl     = 300
  # Points the Route 53 record to the instance's private IP
  records = [aws_instance.employee_api.private_ip] 
}
