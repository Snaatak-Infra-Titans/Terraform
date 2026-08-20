output "instance_id" {
  value = aws_instance.postgresql.id
}

output "private_ip" {
  value = aws_instance.postgresql.private_ip
}

output "availability_zone" {
  value = aws_instance.postgresql.availability_zone
}
