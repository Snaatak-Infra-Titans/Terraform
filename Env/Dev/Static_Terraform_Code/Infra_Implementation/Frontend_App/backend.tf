terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "frontend/instance.tfstate"
    region = "us-east-1"
  }
}
