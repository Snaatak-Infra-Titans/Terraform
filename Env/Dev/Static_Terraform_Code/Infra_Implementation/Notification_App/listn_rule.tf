# Fetching the Listener Rule created by the Network Skeleton
data "aws_lb_listener_rule" "notification_routing" {
  listener_arn = data.aws_lb_listener.app_listener.arn
  priority     = 40
}
