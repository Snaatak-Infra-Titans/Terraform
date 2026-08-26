terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-036253061030-us-east-1"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
