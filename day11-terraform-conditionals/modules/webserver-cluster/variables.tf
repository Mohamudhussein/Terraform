variable "cluster_name" {
  description = "Name of the webserver cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev, staging, or production"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "server_port" {
  description = "Application port"
  type        = number
  default     = 80
}

variable "alb_port" {
  description = "ALB listener port"
  type        = number
  default     = 80
}

variable "instance_security_group_id" {
  description = "Security group for EC2 instances"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group for ALB"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ALB and ASG"
  type        = list(string)
}

variable "enable_detailed_monitoring" {
  description = "Enable CloudWatch alarm creation"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}