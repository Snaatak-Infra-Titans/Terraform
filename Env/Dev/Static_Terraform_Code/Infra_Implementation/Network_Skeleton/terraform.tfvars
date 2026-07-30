aws_region = "us-east-1"

public_subnet_name = "dev_otms_public_subnet_a"

private_route_table_id = "rtb-xxxxxxxx"

nat_gateway_name = "dev_otms_nat_gw"

eip_name = "dev_otms_nat_eip"

destination_cidr = "0.0.0.0/0"

tags = {
  Environment = "dev"
  Application = "otms"
  Owner        = "Infra-Titans"
  CostCenter   = "Snaatak"
}
