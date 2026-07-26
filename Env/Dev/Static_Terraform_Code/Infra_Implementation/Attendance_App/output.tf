output "attendance_security_group_id" {
  description = "The ID of the Attendance security group"
  value       = aws_security_group.attendance.id
}
