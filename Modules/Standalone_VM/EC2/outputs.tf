output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Fixed private IP address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "private_dns" {
  description = "AWS private DNS name of the EC2 instance."
  value       = aws_instance.this.private_dns
}

output "availability_zone" {
  description = "Availability Zone of the EC2 instance."
  value       = aws_instance.this.availability_zone
}
