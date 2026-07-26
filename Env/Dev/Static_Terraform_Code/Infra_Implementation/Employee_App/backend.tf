terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "employee/full.tfstate"
    region = "us-east-1"
  }
}
