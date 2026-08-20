terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-738385003498-us-east-1-an"
    key          = "dev/network-skeleton/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
