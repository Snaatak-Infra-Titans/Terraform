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
# Create Alias Record pointing to Versha's ALB
# -----------------------------------------------------
resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    # DIRECT LINK TO VERSHA'S ALB
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
