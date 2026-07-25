resource "aws_security_group" "scylla_sg" {

  name        = "dev-otms-scylla-sg"
  description = "Security Group for ScyllaDB EC2"
  vpc_id      = data.aws_vpc.network_vpc.id

  tags = {
    Name        = "dev-otms-scylla-sg"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}
