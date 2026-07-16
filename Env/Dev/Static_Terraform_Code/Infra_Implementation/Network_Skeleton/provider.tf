provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Application = var.application
      Owner       = var.owner
      Environment = var.environment
      CostCenter  = var.cost_center
    }
  }
}
