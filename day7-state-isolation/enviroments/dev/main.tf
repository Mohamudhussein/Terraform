/*
  main.tf
  -------------------------------------------------------------------
  Infrastructure for the dev environment.

  This layout gives each environment its own execution directory and its
  own state file, which reduces the risk of accidentally applying changes
  to the wrong environment.
*/

provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_default_vpc" "default" {}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.default_vpc_subnets.ids[0]

  tags = {
    Name        = "${var.project_name}-${var.environment}-web"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}