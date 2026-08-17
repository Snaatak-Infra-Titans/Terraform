# -----------------------------------------------------
# Create public Route 53 hosted zone
# -----------------------------------------------------
resource "aws_route53_zone" "main" {
  name    = var.hosted_zone_name
  comment = "Public hosted zone for ${var.application}-${var.environment}"

  tags = {
    Name        = "${var.environment}-${var.application}-hosted-zone"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

# -----------------------------------------------------
# 1. Alias Record for www.otms.online (Subdomain)
# -----------------------------------------------------
resource "aws_route53_record" "alb_alias_www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name  # "www.otms.online"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

# -----------------------------------------------------
# 2. Alias Record for otms.online (Root / Apex Domain)
# -----------------------------------------------------
resource "aws_route53_record" "alb_alias_root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.hosted_zone_name  # "otms.online"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
