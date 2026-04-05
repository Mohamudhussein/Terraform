variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base project name used for naming and tagging."
  type        = string
  default     = "platform"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for public subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "cluster_name" {
  description = "Webserver cluster name."
  type        = string
  default     = "web-platform"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "Application port."
  type        = number
  default     = 8080
}

variable "min_size" {
  description = "Minimum autoscaling group size."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum autoscaling group size."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired autoscaling group size."
  type        = number
  default     = 1
}