terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"


  default_tags {
    tags = {
      Application = "otms"
      CostCenter  = "Snaatak"
      Environment = "dev"
      Owner       = "Infra-Titans"
    }
  }
}
