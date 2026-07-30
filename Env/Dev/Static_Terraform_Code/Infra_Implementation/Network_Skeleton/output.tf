output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main_igw.id
}

output "vpc_id" {
  description = "The ID of the VPC the Internet Gateway is attached to"
  value       = aws_internet_gateway.main_igw.vpc_id
}
