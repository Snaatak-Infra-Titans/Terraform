terraform {
  backend "s3" {
    bucket       = "dev-otms-terraform-state"
    key          = "scylladb/sg.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
