output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main_vpc.cidr_block
}

output "key_pair_name" {
  description = "Name of the SSH Key Pair"
  value       = aws_key_pair.main_key.key_name
}

output "private_key_pem" {
  description = "Private key content"
  value       = tls_private_key.rsa_key.private_key_pem
  sensitive   = true
}
