terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-dev"
    key          = "network/vpc.tfstate"       
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
