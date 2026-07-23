aws_region           = "us-east-1"

environment          = "dev"
application          = "otms"

owner                = "Infra-Titans"
cost_center          = "Snaatak"

instance_type        = "t3.small"

ami_name             = "notification-es-golden-v1"

ssm_instance_profile = "dev-otms-ssm-role"

# Default VPC Builder Resources
subnet_id            = "subnet-0f43d2e3d0d409398"
security_group_id    = "sg-0c62e66eb60a67ef6"
