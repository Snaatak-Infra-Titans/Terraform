resource "aws_internet_gateway" "main_igw" {
  # IMPLICIT DEPENDENCY: Terraform knows it MUST build the VPC first because we reference its ID here.
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = var.igw_name
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    Application = var.application
  }
}
