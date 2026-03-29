variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app"
}

variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "replica_region" {
  description = "Replica AWS region"
  type        = string
  default     = "us-west-2"
}