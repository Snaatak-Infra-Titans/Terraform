terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "employee/sg.tfstate"
    region = "us-east-1"
  }
}
