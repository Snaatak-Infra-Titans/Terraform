aws_region  = "us-east-1"
environment = "qa"
application = "otms"
cost_center = "Snaatak"
owner       = "Infra-Titans"

vpc_cidr = "10.2.0.0/24"

enable_dns_support   = true
enable_dns_hostnames = true
enable_nat_gateway   = true

nat_gateway_subnet_key = "public-subnet-a"

subnets = {
  "public-subnet-a" = {
    cidr_block              = "10.2.0.0/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    route_table_type        = "public"
    additional_tags         = { Tier = "public" }
  }
  "frontend-subnet-a" = {
    cidr_block              = "10.2.0.32/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "frontend" }
  }
  "backend-subnet-a" = {
    cidr_block              = "10.2.0.64/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "backend" }
  }
  "database-subnet-a" = {
    cidr_block              = "10.2.0.96/27"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    route_table_type        = "private"
    additional_tags         = { Tier = "database" }
  }
  "public-subnet-b" = {
    cidr_block              = "10.2.0.128/27"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    route_table_type        = "public"
    additional_tags         = { Tier = "public" }
  }
}

security_groups = {
  alb = {
    description = "Security group reserved for the QA public application load balancer"
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
    subnet_keys = ["public-subnet-a", "public-subnet-b"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.32/27", from_port = 3000, to_port = 3000 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "public" }
  }

  frontend = {
    subnet_keys = ["frontend-subnet-a"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.0/27", from_port = 3000, to_port = 3000 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.128/27", from_port = 3000, to_port = 3000 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 8080, to_port = 8080 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 8081, to_port = 8081 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 8082, to_port = 8082 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 8085, to_port = 8085 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
      { rule_number = 160, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.0/27", from_port = 1024, to_port = 65535 },
      { rule_number = 170, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.128/27", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "frontend" }
  }

  backend = {
    subnet_keys = ["backend-subnet-a"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.32/27", from_port = 8080, to_port = 8080 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.32/27", from_port = 8081, to_port = 8081 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.32/27", from_port = 8082, to_port = 8082 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.32/27", from_port = 8085, to_port = 8085 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.96/27", from_port = 6379, to_port = 6379 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.96/27", from_port = 5432, to_port = 5432 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.96/27", from_port = 9042, to_port = 9042 },
      { rule_number = 130, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.32/27", from_port = 1024, to_port = 65535 },
      { rule_number = 140, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
      { rule_number = 150, protocol = "6", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 }
    ]
    additional_tags = { Tier = "backend" }
  }

  database = {
    subnet_keys = ["database-subnet-a"]
    ingress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 6379, to_port = 6379 },
      { rule_number = 110, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 5432, to_port = 5432 },
      { rule_number = 120, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 9042, to_port = 9042 }
    ]
    egress = [
      { rule_number = 100, protocol = "6", rule_action = "allow", cidr_block = "10.2.0.64/27", from_port = 1024, to_port = 65535 }
    ]
    additional_tags = { Tier = "database" }
  }
}

tags = {
  ManagedBy = "Terraform"
  Purpose   = "network-skeleton"
}
