variable "aws_region" {
  description = "AWS region for the managed infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_bucket_name" {
  description = "Globally unique S3 bucket name managed through the remote backend"
  type        = string
  default     = "mohamud-hussein-day6-storage-2026"
}