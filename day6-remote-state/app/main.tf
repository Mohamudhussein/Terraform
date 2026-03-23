terraform {
  backend "s3" {
    bucket         = "mohamud-hussein-terraform-state-2026"
    key            = "day6/remote-state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mohamud-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "day6_storage" {
  bucket = var.project_bucket_name

  tags = {
    Name        = "day6-storage"
    Environment = "day6"
    Project     = "terraform-remote-state"
  }
}