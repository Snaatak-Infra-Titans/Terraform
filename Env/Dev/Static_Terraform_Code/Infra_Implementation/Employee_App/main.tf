# ==========================================
# 1. SECURITY GROUP
# ==========================================
resource "aws_security_group" "api_sg" {
  name        = "dev-otms-employee-api-sg"
  description = "Security Group for the Employee API backend service"
  vpc_id      = data.aws_vpc.main_vpc.id

  ingress {
    description     = "Allow HTTP traffic from the ALB on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic to databases and internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "dev-otms-employee-api-sg"
    }
  )
}

# ==========================================
# 2. LAUNCH TEMPLATE
# ==========================================
resource "aws_launch_template" "employee_api" {
  name_prefix   = "dev-otms-employee-api-lt-"
  description   = "Launch template for the Employee API backend"
  image_id      = var.ami_id
  instance_type = "t3.small"

  iam_instance_profile {
    name = "dev-otms-ssm-role"
  }

  key_name = var.key_pair_name

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

  # Propagate tags to the instances
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.common_tags,
      {
        Name = "dev-otms-employee-api-asg-instance"
      }
    )
  }
  
  # Propagate tags to the volumes
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.common_tags,
      {
        Name = "dev-otms-employee-api-vol"
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
