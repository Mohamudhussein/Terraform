variable "aws_region" {
  description = "AWS region for the production environment."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Logical environment name."
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "EC2 instance size for the production environment."
  type        = string
  default     = "t2.medium"
}

variable "project_name" {
  description = "Project identifier used for tagging and naming."
  type        = string
  default     = "day7-state-isolation"
}