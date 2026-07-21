resource "aws_instance" "notification_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # Existing Subnet data 
  subnet_id     = data.aws_subnets.backend_subnets.ids[0]
  key_name      = data.aws_key_pair.existing_key.key_name

  tags = {
    Name = "${var.environment}-${var.application}-notification-server"
  }
}
