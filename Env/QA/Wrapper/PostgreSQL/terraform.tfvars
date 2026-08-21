aws_region  = "us-east-1"
environment = "qa"
application = "postgresql"
owner       = "Infra-Titans"

instance_name = "qa-otms-postgresql"

ami_id        = "<POSTGRESQL_AMI_ID>"
instance_type = "t3.small"

subnet_id = "<QA_DATABASE_SUBNET_ID>"

security_group_ids = [
  "<POSTGRESQL_SECURITY_GROUP_ID>"
]

associate_public_ip = false

iam_instance_profile = "qa-otms-ssm-role"

root_volume_size      = 15
root_volume_type      = "gp3"
delete_on_termination = true

user_data = null

tags = {
  CostCenter = "Snaatak"
  Service    = "postgresql"
  ManagedBy  = "Terraform"
}
