############################################
# ALB Outputs
############################################

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.this.dns_name
}

############################################
# Security Group Output
############################################

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

############################################
# Target Group Outputs
############################################

output "target_group_arns" {
  description = "Target Group ARNs"

  value = {
    frontend     = aws_lb_target_group.services["frontend"].arn
    employee     = aws_lb_target_group.services["employee"].arn
    attendance   = aws_lb_target_group.services["attendance"].arn
    salary       = aws_lb_target_group.services["salary"].arn
    notification = aws_lb_target_group.services["notification"].arn
  }
}
