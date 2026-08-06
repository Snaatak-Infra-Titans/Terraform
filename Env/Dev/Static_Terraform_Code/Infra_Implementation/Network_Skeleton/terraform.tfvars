############################################
# AWS Configuration
############################################

aws_region  = "ap-south-1"
environment = "dev"
application = "otms"
owner        = "Infra-Titans"
cost_center  = "Snaatak"

############################################
# Existing Infrastructure
############################################

vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

public_subnet_a_id = "subnet-xxxxxxxxxxxxxxxxx"
public_subnet_b_id = "subnet-yyyyyyyyyyyyyyyyy"

############################################
# Listener Ports
############################################

http_port  = 80
https_port = 443

############################################
# Target Group Ports
############################################

frontend_port    = 3000
employee_port    = 8080
attendance_port  = 8081
salary_port      = 8082
notification_port = 8085

############################################
# ACM Certificate
############################################

certificate_arn = "arn:aws:acm:us-east-1:547941801997:certificate/c8cfc9e7-cca3-4306-ada2-716b62c097e2"

ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

############################################
# Health Checks
############################################

frontend_health_check     = "/"
employee_health_check     = "/"
attendance_health_check   = "/"
salary_health_check       = "/"
notification_health_check = "/api/v1/notification/health/detail"
