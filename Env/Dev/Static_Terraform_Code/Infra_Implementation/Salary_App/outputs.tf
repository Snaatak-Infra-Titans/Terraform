output "salary_instance_id" {
  description = "Instance ID of the Salary EC2 instance"
  value       = aws_instance.salary.id
}

output "salary_instance_private_ip" {
  description = "Private IP address of the Salary EC2 instance"
  value       = aws_instance.salary.private_ip
}

output "salary_instance_public_ip" {
  description = "Public IP address of the Salary EC2 instance"
  value       = aws_instance.salary.public_ip
}

output "salary_instance_ami" {
  description = "AMI ID used for the Salary EC2 instance"
  value       = aws_instance.salary.ami
}

output "salary_instance_type" {
  description = "Instance type of the Salary EC2 instance"
  value       = aws_instance.salary.instance_type
}

output "salary_instance_subnet_id" {
  description = "Subnet ID where the Salary EC2 instance is created"
  value       = aws_instance.salary.subnet_id
}
