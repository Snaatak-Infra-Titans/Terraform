expected_aws_account_id = "036253061030"
owner                   = "Infra-Titans"
cost_center             = "Snaatak"
deployment_phase        = "foundation"

certificate_arn           = "arn:aws:acm:us-east-1:036253061030:certificate/83fa1207-8938-4873-a7cf-045e73a3877f"
public_route53_zone_id    = "Z025384421USMW8AP0CZK"
private_route53_zone_id   = "Z02920991W3G787FRHSN9"
ssm_instance_profile_name = "dev-otms-ssm-instance-profile"

application_amis = {
  attendance   = "ami-0c6514a2163fe82c2"
  notification = "ami-07883087af6c03650"
  salary       = "ami-07c5f7c1a4a9dcb98"
  employee     = "ami-04eb19e6c6c1fa284"
  frontend     = "ami-01fb6ae81a5bf5665"
}

application_instance_type = "t3.micro"

database_instance_types = {
  postgresql = "t3.micro"
  redis      = "t3.micro"
  scylladb   = "t3.medium"
}

tags = {
  Project = "OTMS"
  Stage   = "Integration"
}
