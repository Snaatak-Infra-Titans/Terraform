aws_region = "us-east-1"

# Attendance API AMI created using Packer
ami_id = "ami-0b99d2f06e67a23ad"

aws_region    = "us-east-1"
environment   = "dev"
application   = "otms"
owner         = "Infra-Titans"
cost_center   = "Snaatak"
vpc_name      = "dev-otms-vpc"
key_name      = "dev-otms-key"
instance_type = "t3.small"
ssm_instance_profile = "dev-otms-ssm-role"
