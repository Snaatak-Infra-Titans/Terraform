resource "aws_instance" "postgresql" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.database_subnet.id

  vpc_security_group_ids = [
    aws_security_group.postgresql.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.ssm.name

  key_name = data.aws_key_pair.existing_key.key_name

  associate_public_ip_address = false

  root_block_device {

    volume_size = 15

    volume_type = "gp3"

    encrypted = true

    delete_on_termination = true
  }

  tags = {

    Name = "${var.environment}-${var.application}-postgresql-ec2"

    Application = "otms"

    Environment = var.environment

    Owner = var.owner

    CostCenter = var.cost_center
  }

}
