variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cluster_name" {
  type    = string
  default = "webservers-day11-dev"
}

variable "use_existing_vpc" {
  type    = bool
  default = true
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}