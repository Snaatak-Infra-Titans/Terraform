# Fetch the network outputs from S3
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "otms-terraform-state-dev"
    key    = "network/full.tfstate"
    region = "us-east-1"
  }
}

# Fetch the existing SSM Instance Profile
data "aws_iam_instance_profile" "ssm_profile" {
  name = "dev-otms-ssm-role"
}
