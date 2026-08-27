output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "elastic_ip" {
  value = aws_eip.this.public_ip
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
