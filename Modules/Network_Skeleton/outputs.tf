############################################
# VPC Outputs
############################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

############################################
# Subnet Outputs
############################################

output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs"

  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id
  }
}

output "public_subnet_ids" {
  description = "Map of public subnet keys to subnet IDs"

  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id
    if var.subnets[key].route_table_type == "public"
  }
}

output "private_subnet_ids" {
  description = "Map of private subnet keys to subnet IDs"

  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id
    if var.subnets[key].route_table_type == "private"
  }
}

############################################
# Internet Gateway Output
############################################

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

############################################
# NAT Gateway Outputs
############################################

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"

  value = var.enable_nat_gateway ? aws_nat_gateway.this[0].id : null
}

output "nat_eip_public_ip" {
  description = "Public IP address allocated to the NAT Gateway"

  value = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

############################################
# Route Table Outputs
############################################

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

############################################
# Security Group Outputs
############################################

output "security_group_ids" {
  description = "Map of Security Group keys to Security Group IDs"

  value = {
    for key, sg in aws_security_group.this :
    key => sg.id
  }
}

############################################
# Network ACL Outputs
############################################

output "network_acl_ids" {
  description = "Map of NACL keys to Network ACL IDs"

  value = {
    for key, nacl in aws_network_acl.this :
    key => nacl.id
  }
}
