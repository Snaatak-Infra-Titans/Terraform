data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-otms-vpc" }
}
