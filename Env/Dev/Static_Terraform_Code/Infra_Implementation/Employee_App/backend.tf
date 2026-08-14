terraform {
  backend "s3" {
    bucket = "dev-otms-terraform-state"
    key    = "employee/instance.tfstate"
    region = "us-east-1"
  }
}
