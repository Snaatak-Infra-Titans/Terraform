locals {
  common_tags = merge(
    {
      Name        = var.instance_name
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
