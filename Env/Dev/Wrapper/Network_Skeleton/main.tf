module "network_skeleton" {
  source = "../../../../Modules/Network_Skeleton"

  application            = var.application
  environment            = var.environment
  owner                  = var.owner
  cost_center            = var.cost_center
  vpc_cidr               = var.vpc_cidr
  enable_dns_support     = var.enable_dns_support
  enable_dns_hostnames   = var.enable_dns_hostnames
  subnets                = var.subnets
  enable_nat_gateway     = var.enable_nat_gateway
  nat_gateway_subnet_key = var.nat_gateway_subnet_key
  security_groups        = var.security_groups
  network_acls           = var.network_acls
  tags                   = var.tags
}
