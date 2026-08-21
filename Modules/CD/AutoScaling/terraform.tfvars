environment = "dev"

application = "otms"

vpc_id = "vpc-031e6592ce40d5e85"

subnet_ids = "subnet-0920bb286c40b80cc"

security_group_id = "sg-0a59207236aaa1692"

application_port = 8080

listener_arn = "<DEV_HTTPS_LISTENER_ARN>"

listener_rule_priority = 100

listener_rule_paths = [
  "/employee/*",
  "/attendance/*",
  "/salary/*"
]

ami_id = ""

instance_type = "t3.small"

iam_instance_profile_name = "otms-ssm-role"
