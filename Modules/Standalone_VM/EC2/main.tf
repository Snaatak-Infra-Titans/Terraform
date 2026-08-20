resource "aws_instance" "this" {

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = var.iam_instance_profile

  user_data = var.user_data

  root_block_device {

    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = var.delete_on_termination
    encrypted             = true

    tags = local.common_tags
  }

  tags = local.common_tags
}
