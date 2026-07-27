resource "aws_iam_role" "attendance_ssm_role" {
  name = "dev-otms-attendance-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name    = "dev-otms-attendance-ssm-role"
      Service = "attendance"
    }
  )
}

resource "aws_iam_role_policy_attachment" "attendance_ssm_core" {
  role       = aws_iam_role.attendance_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "attendance_ssm_profile" {
  name = "dev-otms-attendance-ssm-profile"
  role = aws_iam_role.attendance_ssm_role.name

  tags = merge(
    var.common_tags,
    {
      Name    = "dev-otms-attendance-ssm-profile"
      Service = "attendance"
    }
  )
}
