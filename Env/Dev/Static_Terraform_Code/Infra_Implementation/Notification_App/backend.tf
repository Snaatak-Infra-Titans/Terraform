terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-dev"
    key          = "dev/apps/notification/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
