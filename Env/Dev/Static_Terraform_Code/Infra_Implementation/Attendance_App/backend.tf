terraform {
  backend "s3" {
    bucket = "otms-terraform-state-dev-attendance"
    key    = "env/dev/application/attendance/terraform.tfstate"
    region = "us-east-1"
  }
}
