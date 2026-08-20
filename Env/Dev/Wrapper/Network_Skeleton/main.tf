module "network_skeleton" {
  source = "git::https://github.com/Snaatak-Infra-Titans/Terraform.git//Modules/Network_Skeleton?ref=eb065edc87728b55de655339adeb784cf66fcc60"

  application            = var.application
  environment            = var.environment
  owner                  = var.owner
  cost_center            = var.cost_center
  tags                   = var.tags
  vpc_cidr               = var.vpc_cidr
  enable_dns_support     = var.enable_dns_support
  enable_dns_hostnames   = var.enable_dns_hostnames
  subnets                = var.subnets
  enable_nat_gateway     = var.enable_nat_gateway
  nat_gateway_subnet_key = var.nat_gateway_subnet_key
  security_groups        = var.security_groups
  network_acls           = var.network_acls

  enable_alb                 = var.enable_alb
  alb_security_group_key     = var.alb_security_group_key
  alb_subnet_keys            = var.alb_subnet_keys
  alb_internal               = var.alb_internal
  enable_deletion_protection = var.enable_deletion_protection
  target_groups              = var.target_groups
  default_target_group_key   = var.default_target_group_key
  listener_rules             = var.listener_rules
  certificate_arn            = var.certificate_arn
  ssl_policy                 = var.ssl_policy

  enable_public_route53       = var.enable_public_route53
  public_route53_zone_id      = var.public_route53_zone_id
  public_route53_records      = var.public_route53_records
  enable_private_route53      = var.enable_private_route53
  private_route53_zone_id     = var.private_route53_zone_id
  private_dns_records         = var.private_dns_records
  enable_ssm_instance_profile = var.enable_ssm_instance_profile
}
