module "scylladb" {
  source = "git::https://github.com/Snaatak-Infra-Titans/Terraform.git//Modules/Standalone_VM?ref=SCRUM-483-shivam"

  application = var.application
  environment = var.environment
  owner       = var.owner

  instance_name = var.instance_name
  ami_id        = var.ami_id
  instance_type = var.instance_type

  subnet_id           = var.subnet_id
  security_group_ids  = var.security_group_ids
  associate_public_ip = var.associate_public_ip

  iam_instance_profile = var.iam_instance_profile

  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  delete_on_termination = var.delete_on_termination

  user_data = var.user_data

  tags = var.tags
}
