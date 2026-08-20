ami_id           = "ami-02648a8513226b853"
vpc_name         = "dev-otms-vpc"
alb_sg_name      = "dev-otms-alb-sg"
iam_profile_name = "dev-otms-ssm-role"
common_tags = {
  Application = "otms"
  Owner       = "Infra-Titans"
  Environment = "dev"
  CostCenter  = "Snaatak"
}
