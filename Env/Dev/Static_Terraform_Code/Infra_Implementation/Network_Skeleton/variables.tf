# --- GLOBAL & VPC VARIABLES ---
variable "aws_region"  { type = string }
variable "environment" { type = string }
variable "application" { type = string }
variable "cost_center" { type = string }
variable "owner"       { type = string }
variable "vpc_cidr"    { type = string }
variable "vpc_name"    { type = string }

# --- INFRA & AZ VARIABLES ---
variable "azs"      { type = list(string) }
variable "igw_name" { type = string }

# --- TIER CIDR VARIABLES ---
variable "public_cidr"   { type = string }
variable "frontend_cidr" { type = string }
variable "backend_cidr"  { type = string }
variable "database_cidr" { type = string }

# --- PORT VARIABLES ---
variable "http_port"           { type = number }
variable "https_port"          { type = number }
variable "frontend_port"       { type = number }
variable "employee_port"       { type = number }
variable "attendance_port"     { type = number }
variable "salary_port"         { type = number }
variable "notification_port"   { type = number }
variable "redis_port"          { type = number }
variable "postgres_port"       { type = number }
variable "scylla_port"         { type = number }
variable "ephemeral_from_port" { type = number }
variable "ephemeral_to_port"   { type = number }

# --- ALB VARIABLES ---
variable "certificate_arn"           { type = string }
variable "ssl_policy"                { type = string }
variable "frontend_health_check"     { type = string }
variable "employee_health_check"     { type = string }
variable "attendance_health_check"   { type = string }
variable "salary_health_check"       { type = string }
variable "notification_health_check" { type = string }

# --- SSH KEY VARIABLES (Shivam) ---
variable "key_name" { type = string }
