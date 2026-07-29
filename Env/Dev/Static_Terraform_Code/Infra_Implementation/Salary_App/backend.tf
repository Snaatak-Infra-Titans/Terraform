terraform {
  backend "s3" {
    bucket       = "otms-terraform-state-dev"
    key          = "salary/sg.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
