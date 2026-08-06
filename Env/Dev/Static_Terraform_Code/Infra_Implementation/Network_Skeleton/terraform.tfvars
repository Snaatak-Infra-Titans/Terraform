aws_region  = "ap-south-1"
environment = "dev"
application = "otms"
owner        = "Infra-Titans"
cost_center  = "Snaatak"


vpc_id = "vpc-07b753c29bf89621a"

public_subnet_a_id = "subnet-09e85ba814051b97f"
public_subnet_b_id = "subnet-049af8f3da74399da"


http_port  = 80
https_port = 443


frontend_port    = 3000
employee_port    = 8080
attendance_port  = 8081
salary_port      = 8082
notification_port = 8085


certificate_arn = "arn:aws:acm:ap-south-1:547941801997:certificate/9be43256-666d-4bdb-b7f5-60d63d109416"

ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"


frontend_health_check     = "/"
employee_health_check     = "/"
attendance_health_check   = "/"
salary_health_check       = "/"
notification_health_check = "/api/v1/notification/health/detail"
