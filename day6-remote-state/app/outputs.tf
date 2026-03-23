output "project_bucket_name" {
  value       = aws_s3_bucket.day6_storage.bucket
  description = "S3 bucket managed using the remote backend"
}