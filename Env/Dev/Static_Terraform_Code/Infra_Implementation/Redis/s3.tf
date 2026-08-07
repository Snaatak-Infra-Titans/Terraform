resource "aws_s3_bucket" "ansible_ssm" {
  bucket = "${var.environment}-${var.application}-ansible-ssm"

  tags = {
    Name        = "${var.environment}-${var.application}-ansible-ssm"
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_s3_bucket_versioning" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  rule {
    id     = "cleanup-temp-files"
    status = "Enabled"

    filter {}

    expiration {
      days = 1
    }
  }
}
