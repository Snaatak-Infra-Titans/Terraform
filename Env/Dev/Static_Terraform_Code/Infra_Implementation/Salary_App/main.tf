resource "aws_instance" "salary" {
  ami           = data.aws_ami.salary_ami.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.backend_subnets.ids[0]
  key_name      = var.key_name

  tags = {
    Name = "${var.environment}-${var.application}-salary"
  }
}
