output "instance_id" {
  description = "ID of the PostgreSQL EC2 instance."
  value       = aws_instance.postgresql.id
}

output "private_ip" {
  description = "Private IP address of the PostgreSQL EC2 instance."
  value       = aws_instance.postgresql.private_ip
}
