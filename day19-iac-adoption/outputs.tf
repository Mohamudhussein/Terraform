output "bucket_name" {
  description = "S3 bucket created for the team's first Terraform-managed resource"
  value       = aws_s3_bucket.monitoring_dashboard.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.monitoring_dashboard.arn
}