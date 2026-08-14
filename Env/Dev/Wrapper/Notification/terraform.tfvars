aws_region  = "us-east-1"
environment = "dev"
application = "notification"

vpc_id = "<DEV_VPC_ID>"

subnet_ids = [
  "<DEV_BACKEND_SUBNET_A>",
  "<DEV_BACKEND_SUBNET_B>"
]

ami_id                    = "<NOTIFICATION_GOLDEN_AMI_ID>"
instance_type             = "t3.small"
security_group_id         = "<NOTIFICATION_SECURITY_GROUP_ID>"
iam_instance_profile_name = "dev-otms-ssm-role"

application_port      = 8085
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
listener_rule_priority = 100
listener_rule_paths    = ["/notification/*"]

desired_capacity = 1
min_size         = 1
max_size         = 1

asg_health_check_type         = "ELB"
asg_health_check_grace_period = 300

scaling_metric_type  = "ASGAverageCPUUtilization"
scaling_target_value = 60.0

common_tags = {
  Owner      = "Infra-Titans"
  CostCenter = "Snaatak"
}
