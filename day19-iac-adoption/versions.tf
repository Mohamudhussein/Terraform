terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "mohamud-hussein-tf-state-9f3a2c"
    key            = "day19-iac-adoption/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}