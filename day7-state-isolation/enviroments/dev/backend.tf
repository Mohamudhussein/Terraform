/*
  backend.tf
  -------------------------------------------------------------------
  Remote backend for the dev environment.

  This key is unique to dev, which means its state is fully isolated from
  staging and production.
*/

terraform {
  backend "s3" {
    bucket         = "mohamud-hussein-terraform-state-2026"
    key            = "day7/environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}