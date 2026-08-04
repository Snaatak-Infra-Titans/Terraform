aws_region = "ap-south-1"

environment = "dev"

application = "otms"

vpc_name = "dev-otms-vpc"

public_subnet_name = "dev-otms-public-subnet-a"

private_subnet_name = "dev-otms-private-subnet-a"

destination_cidr = "0.0.0.0/0"

tags = {
  Environment = "dev"
  Application = "otms"
  Owner        = "Infra-Titans"
  CostCenter   = "Snaatak"
}
