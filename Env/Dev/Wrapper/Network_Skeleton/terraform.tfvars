aws_region  = "us-east-1"
environment = "dev"
application = "otms"
cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_cidr = "10.0.0.0/24"

enable_dns_support   = true
enable_dns_hostnames = true
enable_nat_gateway   = true

nat_gateway_subnet_key = "public-subnet-1"

subnets = {
  "public-subnet-1" = {
    cidr_block              = "10.0.0.0/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    route_table_type        = "public"
    additional_tags         = { Tier = "public" }
  }
  "public-subnet-2" = {
    cidr_block              = "10.0.0.32/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    route_table_type        = "public"
    additional_tags         = { Tier = "public" }
  }
  "frontend-subnet-1" = {
    cidr_block              = "10.0.0.64/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "frontend" }
  }
  "frontend-subnet-2" = {
    cidr_block              = "10.0.0.96/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "frontend" }
  }
  "backend-subnet-1" = {
    cidr_block              = "10.0.0.128/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "backend" }
  }
  "backend-subnet-2" = {
    cidr_block              = "10.0.0.160/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "backend" }
  }
  "database-subnet-1" = {
    cidr_block              = "10.0.0.192/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "database" }
  }
  "database-subnet-2" = {
    cidr_block              = "10.0.0.224/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "database" }
  }
}

security_groups = {
  alb = {
    description = "Security group reserved for the public application load balancer"
    ingress = [
      {
        description               = "Allow HTTP from the internet"
        from_port                 = 80
        to_port                   = 80
        protocol                  = "tcp"
        cidr_ipv4                 = "0.0.0.0/0"
        source_security_group_key = null
      },
      {
        description               = "Allow HTTPS from the internet"
        from_port                 = 443
        to_port                   = 443
        protocol                  = "tcp"
        cidr_ipv4                 = "0.0.0.0/0"
        source_security_group_key = null
      }
    ]
    egress = [
      {
        description               = "Allow outbound traffic from the ALB"
        from_port                 = null
        to_port                   = null
        protocol                  = "-1"
        cidr_ipv4                 = "0.0.0.0/0"
        source_security_group_key = null
      }
    ]
    additional_tags = { Tier = "public" }
  }
}

network_acls = {
  public = {
    subnet_keys = ["public-subnet-1", "public-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.64/26", from_port = 1024, to_port = 65535 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.64/26", from_port = 3000, to_port = 3000 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8080, to_port = 8080 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8081, to_port = 8081 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8082, to_port = 8082 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 8085, to_port = 8085 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 160, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "public" }
  }

  frontend = {
    subnet_keys = ["frontend-subnet-1", "frontend-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 3000, to_port = 3000 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 1024, to_port = 65535 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 }
    ]
    additional_tags = { Tier = "frontend" }
  }

  backend = {
    subnet_keys = ["backend-subnet-1", "backend-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 8080, to_port = 8080 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 8081, to_port = 8081 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 8082, to_port = 8082 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 8085, to_port = 8085 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 1024, to_port = 65535 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 160, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.192/26", from_port = 6379, to_port = 6379 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.192/26", from_port = 5432, to_port = 5432 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.192/26", from_port = 9042, to_port = 9042 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.0/26", from_port = 1024, to_port = 65535 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
      { rule_number = 160, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 }
    ]
    additional_tags = { Tier = "backend" }
  }

  database = {
    subnet_keys = ["database-subnet-1", "database-subnet-2"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 6379, to_port = 6379 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 5432, to_port = 5432 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 9042, to_port = 9042 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 6379, to_port = 6379 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 5432, to_port = 5432 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 9042, to_port = 9042 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.0.0.128/26", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "database" }
  }
}

tags = {
  ManagedBy = "Terraform"
  Purpose   = "network-skeleton"
}
