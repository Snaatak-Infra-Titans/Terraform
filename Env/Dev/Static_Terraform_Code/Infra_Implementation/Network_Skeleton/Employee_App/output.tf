output "employee_api_private_ip" {
  description = "The private IP address of the Employee API instance"
  value       = aws_instance.employee_api.private_ip
}

output "employee_api_internal_dns" {
  description = "The Route 53 internal DNS record for the API"
  value       = aws_route53_record.api_dns.fqdn
}
