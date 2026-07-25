terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "frontend/lt.tfstate"
    region = "us-east-1"
  }
}
