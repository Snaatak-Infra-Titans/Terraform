resource "aws_launch_template" "notification_lt" {
  name          = "${var.environment}-${var.application}-notification-lt"
  image_id      = data.aws_ami.notification_app.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.existing_key.key_name

  vpc_security_group_ids = [aws_security_group.notification_sg.id]

  iam_instance_profile {
    name = var.ssm_instance_profile
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
    systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent
    ip link set dev eth0 mtu 1400 || true
    systemctl restart notification-api
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-${var.application}-notification"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
