output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "nat_gateway_public_ip" {
  value = aws_eip.this.public_ip
}

output "elastic_ip_allocation_id" {
  value = aws_eip.this.id
}
