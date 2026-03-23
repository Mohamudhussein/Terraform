/*
  main.tf
  -------------------------------------------------------------------
  Read outputs from the dev environment state file stored in S3.

  This is useful when one layer of infrastructure depends on values
  created by another layer, such as:
  - application layer reading subnet_id from networking
  - compute layer reading VPC outputs
  - shared services reading foundational infrastructure values
*/

data "terraform_remote_state" "dev_environment" {
  backend = "s3"

  config = {
    bucket = "mohamud-hussein-terraform-state-2026"
    key    = "day7/environments/dev/terraform.tfstate"
    region = "us-east-1"
  }
}