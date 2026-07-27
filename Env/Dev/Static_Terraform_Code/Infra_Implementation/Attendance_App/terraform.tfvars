aws_region = "us-east-1"

# Attendance API AMI created using Packer
ami_id = "ami-0b99d2f06e67a23ad"

common_tags = {
  Application = "otms"
  Owner       = "Infra-Titans"
  Environment = "dev"
  CostCenter  = "Snaatak"
  ManagedBy   = "Terraform"
}
