variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "webservers-dev"
}

variable "server_port" {
  description = "Port on which app servers listen"
  type        = number
  default     = 80
}

variable "alb_port" {
  description = "ALB listening port"
  type        = number
  default     = 80
}

variable "enable_autoscaling" {
  description = "Toggle autoscaling policies"
  type        = bool
  default     = true
}

variable "min_size" {
  description = "Minimum instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum instances in ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired instances in ASG"
  type        = number
  default     = 1
}

variable "web_ingress_rules" {
  description = "Ingress rules for the web server security group"
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = {
    http = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    }
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH"
    }
  }
}

variable "iam_users_set" {
  description = "IAM users created using for_each with a set"
  type        = set(string)
  default     = ["alice", "bob", "charlie"]
}

variable "iam_users_map" {
  description = "IAM users created using for_each with a map"
  type = map(object({
    department = string
    admin      = bool
  }))

  default = {
    mohamed = {
      department = "engineering"
      admin      = true
    }
    hussein = {
      department = "operations"
      admin      = false
    }
  }
}