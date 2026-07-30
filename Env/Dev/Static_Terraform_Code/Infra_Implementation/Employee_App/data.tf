
data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:Name"
    values = [var.alb_sg_name]
  }
  vpc_id = data.aws_vpc.main_vpc.id
}


data "aws_lb_target_group" "employee_tg" {
  name = var.target_group_name
}
