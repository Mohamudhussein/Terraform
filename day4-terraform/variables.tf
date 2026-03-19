variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "server_port" {
  description = "The port the web server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "alb_port" {
  description = "Port the ALB will listen on"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "EC2 instance type for the web servers"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "app_name" {
  description = "Name prefix for created resources"
  type        = string
  default     = "day4-web-app"
}