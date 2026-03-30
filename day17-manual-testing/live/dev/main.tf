terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Owner       = "Mohamud"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "day17-manual-testing"
  }
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  cluster_name      = "webserver-cluster"
  environment       = "dev"
  aws_region        = var.aws_region
  server_port       = 80
  instance_type     = "t2.micro"
  min_size          = 1
  max_size          = 2
  desired_capacity  = 1
  server_text       = "Hello from DEV"
  common_tags       = local.common_tags
}