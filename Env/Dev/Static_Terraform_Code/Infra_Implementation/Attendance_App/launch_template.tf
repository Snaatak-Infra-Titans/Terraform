resource "aws_launch_template" "attendance_lt" {
  name          = "${var.environment}-${var.application}-notification-lt"
  image_id      = data.aws_ami.attendance_app.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.existing_key.key_name

  vpc_security_group_ids = [
    aws_security_group.attendance_sg.id
  ]

  iam_instance_profile {
    name = var.ssm_instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-${var.application}-attendance"
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
