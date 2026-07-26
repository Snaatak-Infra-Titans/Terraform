output "postgresql_security_group_id" {
  description = "The ID of the PostgreSQL security group"
  value       = aws_security_group.postgresql.id
}
