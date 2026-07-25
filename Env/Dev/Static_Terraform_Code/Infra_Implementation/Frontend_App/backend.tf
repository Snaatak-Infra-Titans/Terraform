terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "frontend/full.tfstate"
    region = "us-east-1"
  }
}
