output "instance_id" {
  value = aws_instance.scylladb.id
}

output "private_ip" {
  value = aws_instance.scylladb.private_ip
}

output "availability_zone" {
  value = aws_instance.scylladb.availability_zone
}
