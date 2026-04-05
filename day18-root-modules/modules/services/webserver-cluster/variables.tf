variable "project_name" {
  description = "Project name used for naming and tagging."
  type        = string
}

variable "cluster_name" {
  description = "Cluster name prefix."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "server_port" {
  description = "Application port."
  type        = number
}

variable "min_size" {
  description = "Minimum autoscaling group size."
  type        = number
}

variable "max_size" {
  description = "Maximum autoscaling group size."
  type        = number
}

variable "desired_capacity" {
  description = "Desired autoscaling group size."
  type        = number
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the ALB and autoscaling group."
  type        = list(string)
}