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
    cd /tmp
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
    dpkg -i amazon-ssm-agent.deb
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    rm amazon-ssm-agent.deb
    ip link set dev eth0 mtu 1400 || true
    systemctl restart notification || systemctl start notification
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
