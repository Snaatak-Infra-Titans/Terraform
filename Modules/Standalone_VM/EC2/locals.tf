locals {
  common_tags = merge(
    {
      Name        = var.instance_name
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
    },
    var.tags
  )
}
