/*
  main.tf
  -------------------------------------------------------------------
  Workspace-aware infrastructure deployment.

  This configuration uses the active Terraform workspace to:
  - choose the instance size
  - generate environment-specific resource names
  - apply environment tags

  This is useful when one codebase is shared across dev, staging,
  and production.
*/

provider "aws" {
  region = var.aws_region
}

/*
  Pull the latest Amazon Linux 2 AMI from AWS Systems Manager Parameter Store.

  This avoids hardcoding AMI IDs in the configuration and makes the
  deployment more portable and maintainable.
*/
data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

/*
  Use the default VPC so the Day 7 task stays focused on state isolation
  rather than full VPC construction.
*/
resource "aws_default_vpc" "default" {}

/*
  Retrieve subnets from the default VPC so the EC2 instance can be placed
  into an available subnet.
*/
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

/*
  Launch a single EC2 instance whose configuration depends on the active
  workspace.

  Example outcomes:
  - dev        -> t2.micro
  - staging    -> t2.small
  - production -> t2.medium
*/
resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = var.instance_type_by_environment[terraform.workspace]
  subnet_id     = data.aws_subnets.default_vpc_subnets.ids[0]

  tags = {
    Name        = "${var.project_name}-${terraform.workspace}-web"
    Environment = terraform.workspace
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}