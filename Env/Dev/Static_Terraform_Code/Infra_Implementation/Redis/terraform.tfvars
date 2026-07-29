aws_region = "us-east-1"

environment = "dev"
application = "otms"

owner       = "Infra-Titans"
cost_center = "Snaatak"

vpc_name             = "dev-otms-vpc"
database_subnet_name = "dev_otms_database_subnet_a"

key_name             = "dev-otms-key"

instance_type        = "t3.small"

ssm_instance_profile = "dev-otms-ssm-role"
