aws_region           = "us-east-1"

environment          = "dev"
application          = "otms"

owner                = "Infra-Titans"
cost_center          = "Snaatak"

vpc_name             = "dev-otms-vpc"

database_subnet_name = "dev_otms_database_subnet_a"
backend_subnet_name  = "dev_otms_backend_subnet_a"

key_name             = "dev-otms-key"

instance_type        = "t3.small"

ami_owner_id         = "099720109477"
ami_name             = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
