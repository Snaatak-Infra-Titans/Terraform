resource "aws_instance" "postgresql" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = var.database_subnet_id

  vpc_security_group_ids = [
    aws_security_group.postgresql.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.ssm.name

  associate_public_ip_address = false

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${local.name_prefix}-postgresql-ec2"
  }
}
