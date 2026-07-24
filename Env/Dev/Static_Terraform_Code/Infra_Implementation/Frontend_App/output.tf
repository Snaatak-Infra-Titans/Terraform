output "frontend_instance_id" {
  description = "The ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_private_ip" {
  description = "The private IP address of the frontend instance"
  value       = aws_instance.frontend.private_ip
}
