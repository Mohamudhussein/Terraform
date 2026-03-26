variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "ami" {
  description = "AMI for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "Port the app serves traffic on"
  type        = number
  default     = 80
}

variable "subnet_ids" {
  description = "Subnet IDs for ALB and ASGs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "instance_security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 1
}

variable "app_version" {
  description = "Visible version string to render on the webpage"
  type        = string
  default     = "v1"
}

variable "blue_version" {
  description = "Version served by blue ASG"
  type        = string
  default     = "blue-v1"
}

variable "green_version" {
  description = "Version served by green ASG"
  type        = string
  default     = "green-v2"
}

variable "active_environment" {
  description = "Which environment receives traffic: blue or green"
  type        = string
  default     = "blue"

  validation {
    condition     = contains(["blue", "green"], var.active_environment)
    error_message = "active_environment must be blue or green."
  }
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}