############################################
# Common Naming and Tags
############################################

locals {
  name_prefix = "${var.environment}-${var.application}"

  common_tags = merge(
    {
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
    },
    var.tags
  )
}

############################################
# Security Group Rules
############################################

locals {
  security_group_ingress_rules = {
    for item in flatten([
      for sg_key, sg in var.security_groups : [
        for index, rule in sg.ingress : {
          key                = "${sg_key}-ingress-${index}"
          security_group_key = sg_key
          rule               = rule
        }
      ]
    ]) : item.key => item
  }

  security_group_egress_rules = {
    for item in flatten([
      for sg_key, sg in var.security_groups : [
        for index, rule in sg.egress : {
          key                = "${sg_key}-egress-${index}"
          security_group_key = sg_key
          rule               = rule
        }
      ]
    ]) : item.key => item
  }
}

############################################
# NACL Associations and Rules
############################################

locals {
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

  nacl_ingress_rules = {
    for item in flatten([
      for nacl_key, nacl in var.network_acls : [
        for index, rule in nacl.ingress : {
          key      = "${nacl_key}-ingress-${index}"
          nacl_key = nacl_key
          rule     = rule
        }
      ]
    ]) : item.key => item
  }

  nacl_egress_rules = {
    for item in flatten([
      for nacl_key, nacl in var.network_acls : [
        for index, rule in nacl.egress : {
          key      = "${nacl_key}-egress-${index}"
          nacl_key = nacl_key
          rule     = rule
        }
      ]
    ]) : item.key => item
  }
}
