variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "webservers-day12"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "blue_version" {
  type    = string
  default = "Hello World v1"
}

variable "green_version" {
  type    = string
  default = "Hello World v2"
}

variable "active_environment" {
  type    = string
  default = "blue"
}