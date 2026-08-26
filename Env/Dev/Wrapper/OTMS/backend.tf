terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "otms-terraform-state-036253061030-us-east-1"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}
