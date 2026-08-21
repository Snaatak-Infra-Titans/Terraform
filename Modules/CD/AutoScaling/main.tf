module "autoscaling" {
  source = "git::https://github.com/Snaatak-Infra-Titans/Terraform.git//Modules/Auto_Scaling?ref=SCRUM-482-ankita"
  environment               = var.environment
  application               = var.application
  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  security_group_id         = var.security_group_id
  application_port          = var.application_port
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  iam_instance_profile_name = var.iam_instance_profile_name
}
