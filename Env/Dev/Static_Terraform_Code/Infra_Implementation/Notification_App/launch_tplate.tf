resource "aws_launch_template" "notification_lt" {
  name          = "${var.environment}-${var.application}-notification-lt"
  image_id      = data.aws_ami.notification_app.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.existing_key.key_name

  vpc_security_group_ids = [
    aws_security_group.notification_sg.id
  ]

  iam_instance_profile {
    name = var.ssm_instance_profile
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e

# Wait for network
sleep 20

# Ensure SSM Agent is enabled and running
snap start amazon-ssm-agent || true
snap restart amazon-ssm-agent || true

# Set MTU if required
IFACE=$(ip route | awk '/default/ {print $5}')
ip link set dev "$IFACE" mtu 1400 || true

# Restart Notification API
systemctl restart notification-api || true
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-${var.application}-notification"
      Environment = var.environment
      Application = var.application
      Owner       = var.owner
      CostCenter  = var.cost_center
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
