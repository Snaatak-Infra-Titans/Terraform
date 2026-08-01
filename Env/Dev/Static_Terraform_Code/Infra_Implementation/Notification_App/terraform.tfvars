aws_region = "us-east-1"
ami_id     = "ami-0a4eacb31b499aa4d"
instance_type = "t3.micro"
subnet_name = "dev_otms_backend_subnet_a"
iam_instance_profile = "dev-otms-ssm-role"
instance_name = "dev-otms-notification-ec2"

tags = {
  Environment = "dev"
  Application = "otms"
  Owner       = "Infra-Titans"
  CostCenter  = "Snaatak"
}
