aws_region  = "us-east-1"
environment = "dev"
application = "otms"
cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_cidr    = "10.0.0.0/24"
vpc_name    = "dev-otms-vpc"
# --- DEEPAK'S IGW VARIABLES ---
igw_name = "dev-otms-igw"
# --- VERSHA'S ALB VARIABLES ---
certificate_arn = "arn:aws:acm:us-east-1:547941801997:certificate/c8cfc9e7-cca3-4306-ada2-716b62c097e2"
ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

frontend_port     = 3000
employee_port     = 8080
attendance_port   = 8081
salary_port       = 8082
notification_port = 8085

frontend_health_check     = "/"
employee_health_check     = "/"
attendance_health_check   = "/"
salary_health_check       = "/"
notification_health_check = "/"
# --- SHIVAM'S SSH KEY VARIABLES ---
key_name = "dev-otms-key"
# --- ROUTE 53 VARIABLES ---
hosted_zone_name = "otms.online"
domain_name      = "www.otms.online"
