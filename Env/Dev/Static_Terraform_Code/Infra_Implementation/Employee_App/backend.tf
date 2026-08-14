terraform {
  backend "s3" {
    bucket = "dev-otms-terraform-state"
    key    = "employee/asg.tfstate"
    region = "us-east-1"
  }
}
