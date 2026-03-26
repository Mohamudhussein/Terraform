terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name  = "webservers-production"
  instance_type = "t2.medium"
  min_size      = 4
  max_size      = 10
  server_port   = 8080
  server_text   = "Hello from the PRODUCTION webserver cluster"
  alb_port      = 80
  aws_region    = "us-east-1"
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  value = module.webserver_cluster.asg_name
}