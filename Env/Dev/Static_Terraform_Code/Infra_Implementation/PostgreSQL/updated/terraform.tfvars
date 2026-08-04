aws_region = "us-east-1"

environment = "dev"
application = "otms"
owner       = "Infra-Titans"
cost_center = "Snaatak"

# Replace these values with the existing Dev infrastructure IDs.
vpc_id             = "vpc-xxxxxxxxxxxxxxxxx"
database_subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

# Prefer application subnet CIDR instead of allowing the complete VPC,
# depending on the approved infrastructure diagram.
postgresql_allowed_cidr = "10.0.0.0/16"

instance_type = "t3.small"

ssm_instance_profile_name = "dev-otms-ssm-role"

ami_owner_id = "099720109477"
ami_name     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"

root_volume_size = 15
root_volume_type = "gp3"
