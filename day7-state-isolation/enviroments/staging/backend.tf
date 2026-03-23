terraform {
  backend "s3" {
    bucket         = "mohamud-hussein-terraform-state-2026"
    key            = "day7/environments/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}