terraform {
  backend "s3" {
    bucket = "dev-otms-terraform-state"
    key    = "employee/full.tfstate"
    region = "us-east-1"
  }
}
