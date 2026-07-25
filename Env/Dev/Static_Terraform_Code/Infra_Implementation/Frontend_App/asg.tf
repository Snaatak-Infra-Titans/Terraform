resource "aws_autoscaling_group" "frontend_asg" {
  name                = "dev-otms-frontend-asg"
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.frontend_subnet_ids
  
  # Capacity settings
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2

 
  target_group_arns   = [data.terraform_remote_state.network.outputs.target_group_arns["frontend"]]

  
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  # Propagate Name tag to all instances created by the ASG
  tag {
    key                 = "Name"
    value               = "dev-otms-frontend"
    propagate_at_launch = true
  }
}
