module "autoscaling" {
  source = "git::https://github.com/Snaatak-Infra-Titans/Terraform.git//Modules/Auto_Scaling?ref=SCRUM-482-ankita"
  listener_arn             = var.listener_arn
  listener_rule_priority   = var.listener_rule_priority
  listener_rule_paths      = var.listener_rule_paths
  ami_id                   = var.ami_id
  instance_type            = var.instance_type
  iam_instance_profile_name = var.iam_instance_profile_name
}
