/*
  versions.tf
  -------------------------------------------------------------------
  Central place for Terraform and provider version constraints.

  Keeping this separate makes the project easier to maintain and is a
  common production-style practice.
*/

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  /*
    Remote backend configuration for workspace-based state isolation.

    The same codebase is reused across environments, while Terraform
    workspaces create isolated state snapshots for dev, staging, and
    production inside the backend.
  */
  backend "s3" {
    bucket         = "mohamud-hussein-terraform-state-2026"
    key            = "day7/workspaces/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}