output "instance_id" {
  description = "ID of the ScyllaDB EC2 instance"

  value = module.scylladb.instance_id
}

output "private_ip" {
  description = "Private IP address of the ScyllaDB EC2 instance"

  value = module.scylladb.private_ip
}

output "instance_name" {
  description = "Name of the ScyllaDB EC2 instance"

  value = module.scylladb.instance_name
}
