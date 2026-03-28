# Primary bucket (us-east-1)
resource "aws_s3_bucket" "primary" {
  bucket = "${var.project_name}-primary-${random_id.suffix.hex}"

  tags = {
    Name = "Primary Bucket"
  }
}

# Replica bucket (us-west-2)
resource "aws_s3_bucket" "replica" {
  provider = aws.us_west
  bucket   = "${var.project_name}-replica-${random_id.suffix.hex}"

  tags = {
    Name = "Replica Bucket"
  }
}

# Random suffix to avoid bucket name conflicts
resource "random_id" "suffix" {
  byte_length = 4
}