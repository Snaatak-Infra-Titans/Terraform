terraform {
  backend "s3" {
    bucket       = "dev-otms-terraform-state"
    key          = "network/subnets.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
