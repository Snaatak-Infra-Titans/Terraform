terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-dev"
    key          = "notification/instance.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
