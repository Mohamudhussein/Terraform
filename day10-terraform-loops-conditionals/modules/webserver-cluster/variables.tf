variable "cluster_name" {
  description = "Name of the webserver cluster"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "server_port" {
  description = "Port on which the web server runs"
  type        = number
  default     = 8080
}

variable "alb_port" {
  description = "Port exposed by the ALB"
  type        = number
  default     = 80
}

variable "instance_security_group_id" {
  description = "Security group ID for the EC2 instances"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the Auto Scaling Group and ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the ASG"
  type        = number
  default     = 1
}

variable "enable_autoscaling" {
  description = "Whether to create autoscaling policies"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name such as dev or production"
  type        = string
  default     = "dev"
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}