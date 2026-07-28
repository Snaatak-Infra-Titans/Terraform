resource "aws_launch_template" "salary" {
  name_prefix = "${var.environment}-salary-lt-"

  image_id      = var.salary_ami_id
  instance_type = var.instance_type

  update_default_version = true

  iam_instance_profile {
    name = var.instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.salary_security_group_id]
    delete_on_termination       = true
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-salary-instance"
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${var.environment}-salary-volume"
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
    }
  }

  tags = {
    Name        = "${var.environment}-salary-launch-template"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }

  lifecycle {
    create_before_destroy = true
  }
}
