locals {
  application_capacity = var.deployment_phase == "application" ? {
    desired = 1
    min     = 1
    max     = 2
    } : {
    desired = 0
    min     = 0
    max     = 2
  }

  common_tags = merge(
    {
      Application = var.application
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
      ManagedBy   = "Terraform"
    },
    var.tags
  )

  subnets = {
    public-a = {
      cidr_block              = "10.0.0.0/27"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      route_table_type        = "public"
      additional_tags         = { Tier = "public" }
    }
    frontend = {
      cidr_block              = "10.0.0.32/28"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      route_table_type        = "private"
      additional_tags         = { Tier = "frontend" }
    }
    backend = {
      cidr_block              = "10.0.0.64/27"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      route_table_type        = "private"
      additional_tags         = { Tier = "backend" }
    }
    database = {
      cidr_block              = "10.0.0.96/27"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      route_table_type        = "private"
      additional_tags         = { Tier = "database" }
    }
    public-b = {
      cidr_block              = "10.0.0.128/27"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = true
      route_table_type        = "public"
      additional_tags         = { Tier = "public" }
    }
  }

  application_services = {
    employee = {
      ami_id            = var.application_amis["employee"]
      port              = 8080
      health_check_path = "/api/v1/employee/health"
      listener_priority = 10
      listener_paths    = ["/api/v1/employee/*"]
      subnet_key        = "backend"
      security_group    = "backend"
    }
    attendance = {
      ami_id            = var.application_amis["attendance"]
      port              = 8081
      health_check_path = "/api/v1/attendance/health"
      listener_priority = 20
      listener_paths    = ["/api/v1/attendance/*"]
      subnet_key        = "backend"
      security_group    = "backend"
    }
    salary = {
      ami_id            = var.application_amis["salary"]
      port              = 8082
      health_check_path = "/actuator/health"
      listener_priority = 30
      listener_paths    = ["/api/v1/salary/*"]
      subnet_key        = "backend"
      security_group    = "backend"
    }
    notification = {
      ami_id            = var.application_amis["notification"]
      port              = 8085
      health_check_path = "/api/v1/notification/health/detail"
      listener_priority = 40
      listener_paths    = ["/api/v1/notification/*"]
      subnet_key        = "backend"
      security_group    = "backend"
    }
    frontend = {
      ami_id            = var.application_amis["frontend"]
      port              = 3000
      health_check_path = "/"
      listener_priority = 500
      listener_paths    = ["/*"]
      subnet_key        = "frontend"
      security_group    = "frontend"
    }
  }

  database_instances = {
    postgresql = {
      private_ip      = "10.0.0.110"
      security_group  = "postgresql"
      instance_type   = var.database_instance_types["postgresql"]
      root_volume_gib = 20
    }
    redis = {
      private_ip      = "10.0.0.111"
      security_group  = "redis"
      instance_type   = var.database_instance_types["redis"]
      root_volume_gib = 20
    }
    scylladb = {
      private_ip      = "10.0.0.112"
      security_group  = "scylladb"
      instance_type   = var.database_instance_types["scylladb"]
      root_volume_gib = 30
    }
  }

  all_egress = [{
    description               = "Outbound traffic through the shared NAT gateway"
    from_port                 = null
    to_port                   = null
    protocol                  = "-1"
    cidr_ipv4                 = "0.0.0.0/0"
    source_security_group_key = null
  }]

  security_groups = {
    alb = {
      description = "Internet-facing OTMS Application Load Balancer"
      ingress = [
        { description = "HTTP from internet", from_port = 80, to_port = 80, protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null },
        { description = "HTTPS from internet", from_port = 443, to_port = 443, protocol = "tcp", cidr_ipv4 = "0.0.0.0/0", source_security_group_key = null }
      ]
      egress          = local.all_egress
      additional_tags = { Tier = "public" }
    }
    frontend = {
      description = "Frontend application instances"
      ingress = [
        { description = "React serve port from ALB", from_port = 3000, to_port = 3000, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" }
      ]
      egress          = local.all_egress
      additional_tags = { Tier = "frontend" }
    }
    backend = {
      description = "Backend microservice instances"
      ingress = concat(
        [for port in [8080, 8081, 8082, 8085] : { description = "Service port ${port} from ALB", from_port = port, to_port = port, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "alb" }],
        [for port in [8080, 8081, 8082, 8085] : { description = "Service port ${port} from frontend", from_port = port, to_port = port, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "frontend" }],
        [for port in [8080, 8081, 8082, 8085] : { description = "Service port ${port} between backend services", from_port = port, to_port = port, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }]
      )
      egress          = local.all_egress
      additional_tags = { Tier = "backend" }
    }
    postgresql = {
      description = "PostgreSQL database"
      ingress = [
        { description = "PostgreSQL from backend", from_port = 5432, to_port = 5432, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }
      ]
      egress          = local.all_egress
      additional_tags = { Tier = "database" }
    }
    redis = {
      description = "Redis database"
      ingress = [
        { description = "Redis from backend", from_port = 6379, to_port = 6379, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }
      ]
      egress          = local.all_egress
      additional_tags = { Tier = "database" }
    }
    scylladb = {
      description = "ScyllaDB database"
      ingress = [
        { description = "ScyllaDB CQL from backend", from_port = 9042, to_port = 9042, protocol = "tcp", cidr_ipv4 = null, source_security_group_key = "backend" }
      ]
      egress          = local.all_egress
      additional_tags = { Tier = "database" }
    }
  }
}
