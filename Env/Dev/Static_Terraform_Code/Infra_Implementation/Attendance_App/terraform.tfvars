aws_region  = "us-east-1"
environment = "dev"
application = "otms"

vpc_name = "dev-otms-vpc"

# Attendance API AMI created using Packer
ami_id = "ami-024952d6180e2accf"

key_name      = "dev-otms-key"
instance_type = "t3.small"

# This must be an IAM instance profile name.
ssm_instance_profile = "dev-otms-ssm-role"

asg_min_size         = 1
asg_max_size         = 2
asg_desired_capacity = 1

cpu_target_value = 70

common_tags = {
  Application = "otms"
  Owner       = "Infra-Titans"
  Environment = "dev"
  CostCenter  = "Snaatak"
  ManagedBy   = "Terraform"
}
