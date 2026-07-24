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

  # This automatically applies your common tags to EVERY resource
  default_tags {
    tags = var.common_tags
  }
}
