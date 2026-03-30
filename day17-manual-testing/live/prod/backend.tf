terraform {
  backend "s3" {
    bucket         = "mohamud-day17-tf-state-fb26bd63"
    key            = "day17/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mohamud-day17-tf-locks"
    encrypt        = true
  }
}