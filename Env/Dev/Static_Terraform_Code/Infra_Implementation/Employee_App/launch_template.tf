resource "aws_launch_template" "employee_api" {
  name_prefix   = "dev-otms-employee-api-lt-"
  description   = "Launch template for the Employee API backend"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = "dev-otms-ssm-role"
  }

  key_name = data.terraform_remote_state.network.outputs.key_pair_name

  network_interfaces {
    security_groups = [aws_security_group.api_sg.id]
  }

  # Ensure the EBS volume is properly sized
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.common_tags,
      {
        Name = "dev-otms-employee-api-asg-instance"
      }
    )
  }

  tags = merge(
    var.common_tags,
    {
      Name = "dev-otms-employee-api-lt"
    }
  )
}
