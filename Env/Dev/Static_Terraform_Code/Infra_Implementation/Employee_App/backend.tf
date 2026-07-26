terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "employee/lt.tfstate"
    region = "us-east-1"
  }
}
