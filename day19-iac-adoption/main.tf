resource "aws_s3_bucket" "monitoring_dashboard" {
  bucket        = var.dashboard_bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_versioning" "monitoring_dashboard" {
  bucket = aws_s3_bucket.monitoring_dashboard.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "monitoring_dashboard" {
  bucket = aws_s3_bucket.monitoring_dashboard.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "monitoring_dashboard" {
  bucket                  = aws_s3_bucket.monitoring_dashboard.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "monitoring_dashboard" {
  bucket = aws_s3_bucket.monitoring_dashboard.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}