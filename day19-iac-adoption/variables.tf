variable "aws_region" {
  description = "AWS region for the resource"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "day19-iac-adoption"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "mohamud-hussein"
}

variable "dashboard_bucket_name" {
  description = "Name of the S3 bucket created in Phase 1"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even if it contains objects"
  type        = bool
  default     = false
}