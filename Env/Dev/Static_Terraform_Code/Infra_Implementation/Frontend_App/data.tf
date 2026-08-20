
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "otms-terraform-state-dev"
    key    = "network/full.tfstate"
    region = "us-east-1"
  }
}


data "aws_iam_instance_profile" "ssm_profile" {
  name = "dev-otms-ssm-role"
}
