terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-dev"
    key          = "network/vpc.tfstate"       # <-- CHANGE THIS LINE
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
