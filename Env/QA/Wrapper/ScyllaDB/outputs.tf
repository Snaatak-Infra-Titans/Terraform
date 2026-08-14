output "instance_id" {
  description = "ID of the ScyllaDB EC2 instance"

  value = module.scylladb.instance_id
}

output "instance_arn" {
  description = "ARN of the ScyllaDB EC2 instance"

  value = module.scylladb.instance_arn
}

output "private_ip" {
  description = "Private IP address of the ScyllaDB EC2 instance"

  value = module.scylladb.private_ip
}

output "private_dns" {
  description = "Private DNS name of the ScyllaDB EC2 instance"

  value = module.scylladb.private_dns
}

output "availability_zone" {
  description = "Availability Zone of the ScyllaDB EC2 instance"

  value = module.scylladb.availability_zone
}
