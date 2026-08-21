output "instance_id" {
  description = "ID of the PostgreSQL EC2 instance"
  value       = module.postgresql.instance_id
}

output "instance_arn" {
  description = "ARN of the PostgreSQL EC2 instance"
  value       = module.postgresql.instance_arn
}

output "private_ip" {
  description = "Private IP address of the PostgreSQL EC2 instance"
  value       = module.postgresql.private_ip
}

output "private_dns" {
  description = "Private DNS name of the PostgreSQL EC2 instance"
  value       = module.postgresql.private_dns
}

output "availability_zone" {
  description = "Availability Zone of the PostgreSQL EC2 instance"
  value       = module.postgresql.availability_zone
}
