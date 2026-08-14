terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "employee/tg.tfstate"
    region = "us-east-1"
  }
}
