
# -----------------------------------------------------
# Fetch the existing Application Load Balancer
# -----------------------------------------------------

data "aws_lb" "existing" {
  name = var.alb_name
}

# -----------------------------------------------------
# Create public Route 53 hosted zone
# Hosted zone: otms.online
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
# Create www.otms.online alias record
# Point it to the existing ALB
# -----------------------------------------------------

resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.existing.dns_name
    zone_id                = data.aws_lb.existing.zone_id
    evaluate_target_health = true
  }
}

