variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming resources"
  type        = string
  default     = "terraform-secrets-demo"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "db_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing DB credentials"
  type        = string
  default     = "dev/db/credentials-v4"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storage size in GB for the database"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_password_override" {
  description = "Optional override password for testing only. Leave null in real use."
  type        = string
  default     = null
  sensitive   = true
}

variable "db_username_override" {
  description = "Optional override username for testing only. Leave null in real use."
  type        = string
  default     = null
  sensitive   = true
}