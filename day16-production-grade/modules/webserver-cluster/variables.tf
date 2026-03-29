variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "cluster_name" {
  description = "Name of the webserver cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name used in tags"
  type        = string
}

variable "team_name" {
  description = "Owner or team responsible for the infrastructure"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "server_port" {
  description = "Application port"
  type        = number
}

variable "alb_port" {
  description = "ALB listener port"
  type        = number
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
}

variable "desired_capacity" {
  description = "Desired ASG size"
  type        = number
}

variable "cpu_alarm_threshold" {
  description = "CPU threshold for CloudWatch alarm"
  type        = number
}

variable "cpu_alarm_period" {
  description = "Period for CloudWatch alarm"
  type        = number
}

variable "cpu_alarm_evaluation" {
  description = "Evaluation periods for CloudWatch alarm"
  type        = number
}

variable "app_log_retention_days" {
  description = "Retention in days for app logs"
  type        = number
}

variable "user_data" {
  description = "User data script passed to EC2 instances"
  type        = string
}