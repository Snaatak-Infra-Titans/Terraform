terraform {
  backend "s3" {
    bucket = "dev-otms-terraform-state"
    key    = "employee/lt.tfstate"
    region = "us-east-1"
  }
}
