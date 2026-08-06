# AWS configuration
aws_region = "us-east-1"

# Attendance API AMI created using Packer
ami_id = "ami-024952d6180e2accf"

# EC2 configuration
instance_type = "t3.small"

# Existing network resources
vpc_name            = "dev-otms-vpc"
private_subnet_name = "dev_otms_backend_subnet_a"

# Existing Attendance API security group
attendance_security_group_name = "dev-otms-attendance-api-sg"

# Existing IAM instance profile for SSM
ssm_instance_profile_name = "dev-otms-ssm-role"

# Resource tags
environment = "dev"
application = "otms"
owner       = "Infra-Titans"
cost_center = "Snaatak"
