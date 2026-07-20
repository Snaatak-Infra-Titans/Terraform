aws_region  = "us-east-1"
environment = "dev"
application = "otms"

cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_name = "dev-otms-vpc"

public_subnet_a_name = "dev_otms_public_subnet_a"
public_subnet_b_name = "dev_otms_public_subnet_b"

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
