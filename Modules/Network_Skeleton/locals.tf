locals {
  name_prefix = "${var.environment}-${var.application}"

  common_tags = merge(
    {
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  security_group_ingress_rules = {
    for item in flatten([
      for security_group_key, security_group in var.security_groups : [
        for index, rule in security_group.ingress : {
          key                = "${security_group_key}-ingress-${index}"
          security_group_key = security_group_key
          rule               = rule
        }
      ]
    ]) : item.key => item
  }

  security_group_egress_rules = {
    for item in flatten([
      for security_group_key, security_group in var.security_groups : [
        for index, rule in security_group.egress : {
          key                = "${security_group_key}-egress-${index}"
          security_group_key = security_group_key
          rule               = rule
        }
      ]
    ]) : item.key => item
  }

  nacl_associations = {
    for item in flatten([
      for nacl_key, nacl in var.network_acls : [
        for subnet_key in nacl.subnet_keys : {
          key        = "${nacl_key}-${subnet_key}"
          nacl_key   = nacl_key
          subnet_key = subnet_key
        }
      ]
    ]) : item.key => item
  }
}
