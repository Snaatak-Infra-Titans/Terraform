aws_region  = "us-east-1"
environment = "dev"
application = "otms"
cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_name = "dev-otms-vpc"
vpc_cidr = "10.0.0.0/24" 

azs = ["a", "b"]

igw_name = "dev-otms-igw"

public_cidr   = "10.0.0.0/26"
frontend_cidr = "10.0.0.64/26"
backend_cidr  = "10.0.0.128/26"
database_cidr = "10.0.0.192/26"

http_port           = 80
https_port          = 443
frontend_port       = 3000
employee_port       = 8080
attendance_port     = 8081
salary_port         = 8082
notification_port   = 8085
redis_port          = 6379
postgres_port       = 5432
scylla_port         = 9042
ephemeral_from_port = 1024
ephemeral_to_port   = 65535

certificate_arn = "arn:aws:acm:us-east-1:547941801997:certificate/c8cfc9e7-cca3-4306-ada2-716b62c097e2"
ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

frontend_health_check     = "/"
employee_health_check     = "/"
attendance_health_check   = "/"
salary_health_check       = "/"
notification_health_check = "/api/v1/notification/health/detail"

key_name = "dev-otms-key"

# --- ROUTE 53 CONFIGURATION  ---
hosted_zone_name = "otms.online"
domain_name      = "www.otms.online"
