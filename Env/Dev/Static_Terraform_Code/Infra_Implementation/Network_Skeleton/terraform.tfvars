aws_region = "us-east-1"

environment = "dev"

application = "otms"

vpc_name = "dev-otms-vpc"

public_subnet_name = "dev_otms_public_subnet_a"

backend_subnet_name = "dev_otms_backend_subnet_a"

destination_cidr = "0.0.0.0/0"

tags = {
  Environment = "dev"
  Application = "otms"
  Owner       = "Infra-Titans"
  CostCenter  = "Snaatak"
}
