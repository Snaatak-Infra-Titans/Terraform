aws_region  = "us-east-1"
environment = "dev"
application = "otms"
cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_cidr               = "10.0.0.0/24"
enable_dns_support     = true
enable_dns_hostnames   = true
enable_nat_gateway     = true
nat_gateway_subnet_key = "public-subnet-1"

subnets = {
  public-subnet-1 = {
    cidr_block              = "10.0.0.0/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    route_table_type        = "public"
    additional_tags         = { Tier = "public" }
  }
  public-subnet-2 = {
    cidr_block              = "10.0.0.32/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    route_table_type        = "public"
    additional_tags         = { Tier = "public" }
  }
  frontend-subnet-1 = {
    cidr_block              = "10.0.0.64/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "frontend" }
  }
  frontend-subnet-2 = {
    cidr_block              = "10.0.0.96/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "frontend" }
  }
  backend-subnet-1 = {
    cidr_block              = "10.0.0.128/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "backend" }
  }
  backend-subnet-2 = {
    cidr_block              = "10.0.0.160/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "backend" }
  }
  database-subnet-1 = {
    cidr_block              = "10.0.0.192/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "database" }
  }
  database-subnet-2 = {
    cidr_block              = "10.0.0.224/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "database" }
  }
}

security_groups = {
  alb = {
    description = "Public Application Load Balancer"
    ingress = [
      { description = "HTTP from internet", from_port = 80, to_port = 80, protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null },
      { description = "HTTPS from internet", from_port = 443, to_port = 443, protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    egress = [
      { description = "ALB outbound to targets", from_port = null, to_port = null, protocol = "-1", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    additional_tags = { Tier = "public" }
  }

  frontend = {
    description = "Frontend application instances"
    ingress = [
      { description = "Frontend traffic from ALB", from_port = 3000, to_port = 3000, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" }
    ]
    egress = [
      { description = "Frontend outbound", from_port = null, to_port = null, protocol = "-1", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    additional_tags = { Tier = "frontend" }
  }

  backend = {
    description = "Backend microservice instances"
    ingress = [
      { description = "Employee traffic from ALB", from_port = 8080, to_port = 8080, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" },
      { description = "Attendance traffic from ALB", from_port = 8081, to_port = 8081, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" },
      { description = "Salary traffic from ALB", from_port = 8082, to_port = 8082, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" },
      { description = "Notification traffic from ALB", from_port = 8085, to_port = 8085, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" },
      { description = "Employee traffic from frontend", from_port = 8080, to_port = 8080, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "frontend" },
      { description = "Attendance traffic from frontend", from_port = 8081, to_port = 8081, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "frontend" },
      { description = "Salary traffic from frontend", from_port = 8082, to_port = 8082, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "frontend" },
      { description = "Notification traffic from frontend", from_port = 8085, to_port = 8085, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "frontend" }
    ]
    egress = [
      { description = "Backend outbound", from_port = null, to_port = null, protocol = "-1", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    additional_tags = { Tier = "backend" }
  }

  redis = {
    description = "Redis instances"
    ingress = [
      { description = "Redis from backend", from_port = 6379, to_port = 6379, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }
    ]
    egress = [
      { description = "Redis outbound", from_port = null, to_port = null, protocol = "-1", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    additional_tags = { Tier = "database" }
  }

  postgresql = {
    description = "PostgreSQL instances"
    ingress = [
      { description = "PostgreSQL from backend", from_port = 5432, to_port = 5432, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }
    ]
    egress = [
      { description = "PostgreSQL outbound", from_port = null, to_port = null, protocol = "-1", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    additional_tags = { Tier = "database" }
  }

  scylla = {
    description = "ScyllaDB instances"
    ingress = [
      { description = "ScyllaDB from backend", from_port = 9042, to_port = 9042, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }
    ]
    egress = [
      { description = "ScyllaDB outbound", from_port = null, to_port = null, protocol = "-1", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
    ]
    additional_tags = { Tier = "database" }
  }
}

network_acls = {
  public = {
    subnet_keys = ["public-subnet-1", "public-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.64/26", from_port = 3000, to_port = 3000 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8080, to_port = 8082 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8085, to_port = 8085 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "public" }
  }

  frontend = {
    subnet_keys = ["frontend-subnet-1", "frontend-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 3000, to_port = 3000 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 1024, to_port = 65535 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8080, to_port = 8082 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8085, to_port = 8085 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 }
    ]
    additional_tags = { Tier = "frontend" }
  }

  backend = {
    subnet_keys = ["backend-subnet-1", "backend-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 8080, to_port = 8082 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 8085, to_port = 8085 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.64/26", from_port = 8080, to_port = 8082 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.64/26", from_port = 8085, to_port = 8085 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.192/26", from_port = 5432, to_port = 5432 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.192/26", from_port = 6379, to_port = 6379 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.192/26", from_port = 9042, to_port = 9042 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 1024, to_port = 65535 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 }
    ]
    additional_tags = { Tier = "backend" }
  }

  database = {
    subnet_keys = ["database-subnet-1", "database-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 5432, to_port = 5432 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 6379, to_port = 6379 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 9042, to_port = 9042 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "database" }
  }
}

enable_alb                 = true
alb_security_group_key     = "alb"
alb_subnet_keys            = ["public-subnet-1", "public-subnet-2"]
alb_internal               = false
enable_deletion_protection = false

certificate_arn = "arn:aws:acm:us-east-1:738385003498:certificate/c444fe92-a4bd-4eea-967b-72b4dde70ef8"
ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

target_groups = {
  frontend     = { port = 3000, protocol = "HTTP", target_type = "instance", health_check_path = "/", health_check_matcher = "200-399" }
  employee     = { port = 8080, protocol = "HTTP", target_type = "instance", health_check_path = "/api/v1/employee/health", health_check_matcher = "200-399" }
  attendance   = { port = 8081, protocol = "HTTP", target_type = "instance", health_check_path = "/api/v1/attendance/health", health_check_matcher = "200-399" }
  salary       = { port = 8082, protocol = "HTTP", target_type = "instance", health_check_path = "/actuator/health", health_check_matcher = "200-399" }
  notification = { port = 8085, protocol = "HTTP", target_type = "instance", health_check_path = "/api/v1/notification/health/detail", health_check_matcher = "200-399" }
}

default_target_group_key = "frontend"

listener_rules = {
  employee     = { priority = 10, path_patterns = ["/api/v1/employee/*"], target_group_key = "employee" }
  attendance   = { priority = 20, path_patterns = ["/api/v1/attendance/*"], target_group_key = "attendance" }
  salary       = { priority = 30, path_patterns = ["/api/v1/salary/*"], target_group_key = "salary" }
  notification = { priority = 40, path_patterns = ["/api/v1/notification/*"], target_group_key = "notification" }
}

# Hosted zones are persistent and are not created or destroyed by this environment wrapper.
# Set each enable flag to true and provide its zone ID after creating the zones.
enable_public_route53  = true
public_route53_zone_id = "Z10193732GFA7IQJG6O66"
public_route53_records = ["otms.online", "www.otms.online"]

enable_private_route53  = true
private_route53_zone_id = "Z02725882WKXUB55ZATU0"
private_dns_records     = {}

enable_ssm_instance_profile = true

tags = {
  Purpose = "network-skeleton"
}
