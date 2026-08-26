resource "terraform_data" "account_guardrail" {
  input = data.aws_caller_identity.current.account_id

  lifecycle {
    precondition {
      condition     = data.aws_caller_identity.current.account_id == var.expected_aws_account_id
      error_message = "Wrong AWS account. Expected ${var.expected_aws_account_id}, received ${data.aws_caller_identity.current.account_id}."
    }
  }
}

module "network_skeleton" {
  source = "../../../../Modules/Network_Skeleton"

  application            = var.application
  environment            = var.environment
  owner                  = var.owner
  cost_center            = var.cost_center
  tags                   = var.tags
  vpc_cidr               = var.vpc_cidr
  subnets                = local.subnets
  enable_nat_gateway     = true
  nat_gateway_subnet_key = "public-a"
  security_groups        = local.security_groups
  network_acls           = {}

  enable_alb                 = true
  alb_security_group_key     = "alb"
  alb_subnet_keys            = ["public-a", "public-b"]
  alb_internal               = false
  enable_deletion_protection = false
  certificate_arn            = var.certificate_arn

  enable_public_route53  = true
  public_route53_zone_id = var.public_route53_zone_id
  public_route53_records = ["otms.online", "www.otms.online"]

  enable_private_route53  = true
  private_route53_zone_id = var.private_route53_zone_id

  # Reuse the existing account-level profile shown in the approved design.
  enable_ssm_instance_profile = false

  depends_on = [terraform_data.account_guardrail]
}

module "application" {
  for_each = local.application_services
  source   = "../../../../Modules/Auto_Scaling"

  environment               = var.environment
  application               = each.key
  common_tags               = local.common_tags
  vpc_id                    = module.network_skeleton.vpc_id
  subnet_ids                = [module.network_skeleton.subnet_ids[each.value.subnet_key]]
  security_group_id         = module.network_skeleton.security_group_ids[each.value.security_group]
  application_port          = each.value.port
  health_check_path         = each.value.health_check_path
  listener_arn              = module.network_skeleton.https_listener_arn
  listener_rule_priority    = each.value.listener_priority
  listener_rule_paths       = each.value.listener_paths
  ami_id                    = each.value.ami_id
  instance_type             = var.application_instance_type
  iam_instance_profile_name = data.aws_iam_instance_profile.ssm.name
  desired_capacity          = local.application_capacity.desired
  min_size                  = local.application_capacity.min
  max_size                  = local.application_capacity.max
}

module "database" {
  for_each = local.database_instances
  source   = "../../../../Modules/Standalone_VM/EC2"

  application          = each.key
  environment          = var.environment
  owner                = var.owner
  instance_name        = "${var.environment}-otms-${each.key}"
  ami_id               = data.aws_ami.ubuntu_2404.id
  instance_type        = each.value.instance_type
  subnet_id            = module.network_skeleton.subnet_ids["database"]
  private_ip           = each.value.private_ip
  security_group_ids   = [module.network_skeleton.security_group_ids[each.value.security_group]]
  iam_instance_profile = data.aws_iam_instance_profile.ssm.name
  root_volume_size     = each.value.root_volume_gib
  tags                 = var.tags
}

resource "aws_route53_record" "database" {
  for_each = local.database_instances

  zone_id = var.private_route53_zone_id
  name    = "otms.${each.key}.internal"
  type    = "A"
  ttl     = 60
  records = [module.database[each.key].private_ip]

  depends_on = [module.network_skeleton]
}
