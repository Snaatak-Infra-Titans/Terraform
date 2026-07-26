resource "aws_autoscaling_group" "employee_api" {
  name = "dev-otms-employee-api-asg"


  vpc_zone_identifier = [data.terraform_remote_state.network.outputs.backend_subnet_ids[0]]

  desired_capacity = 1
  min_size         = 1
  max_size         = 2


  target_group_arns = [data.terraform_remote_state.network.outputs.target_group_arns["employee"]]


  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.employee_api.id
    version = "$Latest"
  }


  tag {
    key                 = "Name"
    value               = "dev-otms-employee-api-asg-instance"
    propagate_at_launch = true
  }


  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
