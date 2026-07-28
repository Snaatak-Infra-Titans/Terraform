data "aws_lb_target_group" "salary_tg" {
  name = "${var.environment}-${var.application}-salary-tg"
}
