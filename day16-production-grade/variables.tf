variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the webserver cluster"
  type        = string
  default     = "webservers-dev"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project name used in tags"
  type        = string
  default     = "terraform-challenge"
}

variable "team_name" {
  description = "Owner or team responsible for the infrastructure"
  type        = string
  default     = "mohamud"
}


variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^t[23]\\.", var.instance_type))
    error_message = "Instance type must be from the t2 or t3 family."
  }
}

variable "server_port" {
  description = "Port the application listens on"
  type        = number
  default     = 80
}

variable "alb_port" {
  description = "Port exposed by the Application Load Balancer"
  type        = number
  default     = 80
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "cpu_alarm_threshold" {
  description = "CPU percentage threshold for the alarm"
  type        = number
  default     = 80
}

variable "cpu_alarm_period" {
  description = "CloudWatch alarm evaluation period in seconds"
  type        = number
  default     = 120
}

variable "cpu_alarm_evaluation" {
  description = "Number of evaluation periods before alarm triggers"
  type        = number
  default     = 2
}

variable "app_log_retention_days" {
  description = "Retention in days for application log groups"
  type        = number
  default     = 14
}

variable "user_data" {
  description = "User data script for web servers"
  type        = string
  default     = <<-EOT
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Hello World" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOT
}