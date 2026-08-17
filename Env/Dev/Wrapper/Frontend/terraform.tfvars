aws_region  = "us-east-1"
environment = "dev"
application = "otms-frontend"

vpc_id = "<DEV_VPC_ID>"

subnet_ids = [
  "<DEV_FRONTEND_PRIVATE_SUBNET_A>",
  "<DEV_FRONTEND_PRIVATE_SUBNET_B>"
]

ami_id                    = "<FRONTEND_GOLDEN_AMI_ID>"
instance_type             = "t3.micro"
security_group_id         = "<FRONTEND_SECURITY_GROUP_ID>"
iam_instance_profile_name = "dev-otms-ssm-role"

application_port      = 3000
target_group_protocol = "HTTP"
target_type           = "instance"

health_check_enabled  = true
health_check_protocol = "HTTP"
health_check_path     = "/"
health_check_port     = "traffic-port"

health_check_interval = 30
health_check_timeout  = 5
healthy_threshold     = 3
unhealthy_threshold   = 3
health_check_matcher  = "200"

listener_arn           = "<DEV_ALB_LISTENER_ARN>"
listener_rule_priority = 50000
listener_rule_paths    = ["/*"]

desired_capacity = 1
min_size         = 1
max_size         = 2

asg_health_check_type         = "ELB"
asg_health_check_grace_period = 300

scaling_metric_type  = "ASGAverageCPUUtilization"
scaling_target_value = 50

common_tags = {
  Application = "otms"
  Owner       = "Infra-Titans"
  Environment = "dev"
  CostCenter  = "Snaatak"
}
