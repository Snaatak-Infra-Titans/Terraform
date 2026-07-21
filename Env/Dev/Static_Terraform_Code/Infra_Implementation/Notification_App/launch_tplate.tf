resource "aws_launch_template" "notification_lt" {
  name_prefix   = "${var.environment}-${var.application}-notification-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.existing_key.key_name

  
  vpc_security_group_ids = [aws_security_group.notification_sg.id]


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-${var.application}-notification-app"
    }
  }

  # Terraform best practice: Naya template banane ke baad hi purana delete ho
  lifecycle {
    create_before_destroy = true
  }
}
