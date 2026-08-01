resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.selected.id
  iam_instance_profile   = data.aws_iam_instance_profile.selected.name

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}
