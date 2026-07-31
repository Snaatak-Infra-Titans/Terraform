data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-otms-vpc" }
}

# Lookup Attendance App Security Group
data "aws_security_group" "attendance" {
  tags = { Name = "${var.environment}-otms-attendance-sg" }
}
