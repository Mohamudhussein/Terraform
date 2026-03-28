output "primary_bucket" {
  value = aws_s3_bucket.primary.bucket
}

output "replica_bucket" {
  value = aws_s3_bucket.replica.bucket
}