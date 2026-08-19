application = "salary"
environment = "QA"
owner       = "Versha"

instance_name = "salary-qa-ec2"

ami_id = "ami-xxxxxxxxxxxxxxxxx"

subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

security_group_ids = [
  "sg-xxxxxxxxxxxxxxxxx"
]

instance_type       = "t3.micro"
associate_public_ip = false

root_volume_size = 20
root_volume_type = "gp3"

delete_on_termination = true

tags = {
  Environment = "QA"
  Application = "salary"
  ManagedBy   = "Terraform"
}
