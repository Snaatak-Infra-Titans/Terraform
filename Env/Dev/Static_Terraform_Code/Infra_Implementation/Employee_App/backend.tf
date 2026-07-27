terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "employee/asg.tfstate"
    region = "us-east-1"
  }
}
