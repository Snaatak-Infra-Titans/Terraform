terraform {
  backend "s3" {
    bucket       = "dev-otms-terraform-state-352742379893"
    key          = "frontend/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
