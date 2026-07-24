aws_region  = "us-east-1"
environment = "dev"
application = "otms"
cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_name = "dev-otms-vpc"
vpc_cidr = "10.0.0.0/24" # Remains /24

azs = ["a", "b"]

igw_name = "dev-otms-igw"

# --- TIER CIDRS (Fits perfectly in /24) ---
public_cidr   = "10.0.0.0/26"
frontend_cidr = "10.0.0.64/26"
backend_cidr  = "10.0.0.128/26"
database_cidr = "10.0.0.192/26"

# --- PORTS ---
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
