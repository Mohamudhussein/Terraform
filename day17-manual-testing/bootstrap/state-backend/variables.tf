variable "aws_region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the S3 state bucket. Final bucket name will be unique."
  type        = string
  default     = "mohamud-day17-tf-state"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "mohamud-day17-tf-locks"
}