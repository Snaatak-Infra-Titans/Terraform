terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev-788572613316"
    key    = "env/dev/application/attendance/terraform.tfstate"
    region = "us-east-1"
  }
}
