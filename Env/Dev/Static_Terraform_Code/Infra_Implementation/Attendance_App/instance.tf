resource "aws_instance" "attendance_api" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.attendance.id

  vpc_security_group_ids = [
    data.aws_security_group.attendance_api.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.attendance_ssm.name

  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = "${var.environment}-${var.application}-attendance-api"
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    Service     = "attendance-api"
    ManagedBy   = "Terraform"
  }
}
