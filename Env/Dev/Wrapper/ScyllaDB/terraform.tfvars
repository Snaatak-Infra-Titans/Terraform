aws_region  = "us-east-1"
environment = "dev"
application = "scylladb"
owner       = "Infra-Titans"

instance_name = "dev-otms-scylladb"

ami_id        = "<SCYLLADB_AMI_ID>"
instance_type = "t3.small"

subnet_id = "<DEV_DATABASE_SUBNET_A>"

security_group_ids = [
  "<SCYLLADB_SECURITY_GROUP_ID>"
]

associate_public_ip = false

iam_instance_profile = "dev-otms-ssm-role"

root_volume_size      = 15
root_volume_type      = "gp3"
delete_on_termination = true

user_data = null

tags = {
  CostCenter = "Snaatak"
}
