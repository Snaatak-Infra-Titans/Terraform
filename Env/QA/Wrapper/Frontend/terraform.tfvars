aws_region  = "us-east-1"
environment = "qa"
application = "otms-frontend"

# QA Network
vpc_id = "<QA_VPC_ID>"

subnet_ids = [
  "<QA_FRONTEND_PRIVATE_SUBNET_1>",
  "<QA_FRONTEND_PRIVATE_SUBNET_2>"
]

# Frontend Compute
ami_id                    = "<QA_FRONTEND_GOLDEN_AMI_ID>"
instance_type             = "t3.small"
security_group_id         = "<QA_FRONTEND_SECURITY_GROUP_ID>"
iam_instance_profile_name = "qa-otms-ssm-role"

# Frontend Application
application_port      = 3000
target_group_protocol = "HTTP"
target_type           = "instance"

# Target Group Health Check
health_check_enabled  = true
health_check_protocol = "HTTP"
health_check_path     = "/"
health_check_port     = "traffic-port"

health_check_interval = 30
health_check_timeout  = 5
healthy_threshold     = 3
unhealthy_threshold   = 3
health_check_matcher  = "200"

# Existing QA ALB
listener_arn = "<QA_ALB_LISTENER_ARN>"

# Frontend acts as catch-all after API-specific rules.
# Keep API listener rules at lower priority numbers.
listener_rule_priority = 50000
listener_rule_paths    = ["/*"]

# Auto Scaling
desired_capacity = 1
min_size         = 1
max_size         = 2

asg_health_check_type         = "ELB"
asg_health_check_grace_period = 300

# Scaling Policy
scaling_metric_type  = "ASGAverageCPUUtilization"
scaling_target_value = 60

# Standard Cost Allocation / Governance Tags
common_tags = {
  Application = "otms"
  Owner       = "Infra-Titans"
  Environment = "qa"
  CostCenter  = "Snaatak"
}
