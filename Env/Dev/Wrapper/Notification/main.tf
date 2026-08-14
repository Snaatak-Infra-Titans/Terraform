module "notification" {
  source = "git::https://github.com/Snaatak-Infra-Titans/Terraform.git//Modules/Auto_Scaling?ref=SCRUM-482-ankita"

  # General
  aws_region  = var.aws_region
  vpc_id      = var.vpc_id
  environment = var.environment
  application = var.application
  common_tags = var.common_tags

  # Target Group
  application_port      = var.application_port
  target_group_protocol = var.target_group_protocol
  target_type           = var.target_type

  health_check_enabled     = var.health_check_enabled
  health_check_protocol    = var.health_check_protocol
  health_check_path        = var.health_check_path
  health_check_port        = var.health_check_port
  health_check_interval    = var.health_check_interval
  health_check_timeout     = var.health_check_timeout
  healthy_threshold        = var.healthy_threshold
  unhealthy_threshold      = var.unhealthy_threshold
  health_check_matcher     = var.health_check_matcher


  # Listener Rule
  listener_arn           = var.listener_arn
  listener_rule_priority = var.listener_rule_priority
  listener_rule_paths    = var.listener_rule_paths

  # Launch Template
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  security_group_id         = var.security_group_id
  iam_instance_profile_name = var.iam_instance_profile_name

  # Auto Scaling Group
  subnet_ids                   = var.subnet_ids
  desired_capacity             = var.desired_capacity
  min_size                     = var.min_size
  max_size                     = var.max_size
  asg_health_check_type        = var.asg_health_check_type
  asg_health_check_grace_period = var.asg_health_check_grace_period

  # Auto Scaling Policy
  scaling_metric_type  = var.scaling_metric_type
  scaling_target_value = var.scaling_target_value
}
