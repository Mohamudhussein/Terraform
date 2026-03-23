/*
  variables.tf
  -------------------------------------------------------------------
  Input variables for the workspace-based deployment.

  Instance sizing is controlled through a map keyed by workspace name.
  This allows the same code to behave differently in each environment.
*/

variable "aws_region" {
  description = "AWS region where infrastructure will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "instance_type_by_environment" {
  description = "EC2 instance type selected based on the active Terraform workspace."
  type        = map(string)

  default = {
    dev        = "t2.micro"
    staging    = "t2.small"
    production = "t2.medium"
  }
}

variable "project_name" {
  description = "Project identifier used in resource naming and tagging."
  type        = string
  default     = "day7-state-isolation"
}