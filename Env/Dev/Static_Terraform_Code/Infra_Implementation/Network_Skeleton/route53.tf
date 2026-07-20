# Lookup the existing public Route 53 hosted zone
data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = false
}

# Create www.otms.online alias record pointing to the ALB
resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
