terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev"
    key    = "frontend/asg.tfstate"
    region = "us-east-1"
  }
}
