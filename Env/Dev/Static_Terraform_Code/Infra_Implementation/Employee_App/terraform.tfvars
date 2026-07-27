aws_region       = "us-east-1"
environment      = "dev"
application_name = "employee"
owner            = "Pawan"
cost_center      = "CC-EMPLOYEE-DEV"

ami_id             = "ami-04d8312c0e38c4b8a"
instance_type      = "t3.micro"
security_group_ids = ["sg-0123456789abcdef0"] # Created in Ticket 430

vpc_zone_identifier = [
  "subnet-0123456789abcdef0",
  "subnet-0123456789abcdef1"
]

asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 1

target_group_arns = [
  "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-employee-tg/1234567890123456" # Created in Ticket 432
]
