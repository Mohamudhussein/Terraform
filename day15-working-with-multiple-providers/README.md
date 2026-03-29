Day 15: Working with Multiple Providers – Part 2
Overview

This project demonstrates advanced Terraform concepts from Chapter 7 of Terraform: Up & Running. The focus is on:

Using multiple provider configurations (AWS regions)
Passing provider aliases into reusable modules
Managing local Docker containers using Terraform
Understanding (and preparing) EKS + Kubernetes integration

This project is split into three parts:

Multi-region AWS deployment using provider aliases
Docker container deployment with Terraform
EKS configuration (prepared but not fully executed)
Project Structure
day15-working-with-multiple-providers/
│
├── multi-region-app/
│   ├── modules/
│   │   └── multi-region-app/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   └── live/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
├── docker-nginx/
│   ├── main.tf
│   ├── versions.tf
│   └── outputs.tf
│
└── eks-nginx/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
Part 1: Multi-Provider (AWS Multi-Region)
Goal

Deploy resources in two AWS regions using provider aliases.

Important Concept

Modules must not define their own providers when aliases are involved.
Instead, providers are defined in the root and passed into the module.

Module Code
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.primary, aws.replica]
    }
  }
}

resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = "${var.app_name}-primary-${var.suffix}"
}

resource "aws_s3_bucket" "replica" {
  provider = aws.replica
  bucket   = "${var.app_name}-replica-${var.suffix}"
}
Root Configuration
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "replica"
  region = var.replica_region
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "multi_region_app" {
  source   = "../modules/multi-region-app"
  app_name = var.app_name
  suffix   = random_id.suffix.hex

  providers = {
    aws.primary = aws.primary
    aws.replica = aws.replica
  }
}
Commands Used (VERY IMPORTANT)

Run ONLY from:

multi-region-app/live
terraform init
terraform plan
terraform apply
Output
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

primary_bucket_name = "multi-region-demo-primary-3b90217a"
replica_bucket_name = "multi-region-demo-replica-3b90217a"
Key Learning
configuration_aliases tells Terraform which provider aliases the module expects
The root module controls provider configuration
This pattern makes modules reusable across environments
Part 2: Docker Deployment (Local Infrastructure)
Goal

Deploy an Nginx container using Terraform.

Configuration
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "terraform-nginx"

  ports {
    internal = 80
    external = 8080
  }
}
Commands Used

Run from:

docker-nginx
terraform init
terraform plan
terraform apply

Verify container:

docker ps
Output
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

nginx_url = "http://localhost:8080"

Docker verification:

CONTAINER ID   IMAGE          PORTS                  NAMES
c69ad0350c66   nginx:latest   0.0.0.0:8080->80/tcp   terraform-nginx
Access the App

Open in browser:

http://localhost:8080
Cleanup (IMPORTANT)
terraform destroy
Part 3: EKS (Prepared Only)
Goal

Provision EKS and deploy Kubernetes workloads using Terraform.

Kubernetes Authentication Concept

Terraform uses:

aws eks get-token --cluster-name <cluster-name>

This is configured using an exec block inside the Kubernetes provider.

Why Not Fully Executed

The Kubernetes deployment failed due to network access issues to the EKS API endpoint (private endpoint not reachable from local machine).

Key Learnings
1. Provider Aliasing
Modules must receive providers from the root
Never define aliased providers inside modules
2. configuration_aliases
Declares expected provider aliases
Required for Terraform to map providers correctly
3. Terraform + Docker
Terraform can manage local infrastructure
Not limited to cloud
4. Kubernetes Provider
Uses EKS outputs (endpoint + cert)
Authenticates via AWS CLI token
Cost Awareness (Important)

EKS creates:

Control plane
EC2 worker nodes
VPC + subnets
NAT Gateway
Security groups
IAM roles

Running for 24 hours can incur significant cost.

Always run:

terraform destroy
Challenges and Fixes
Issue 1: Running Terraform in wrong folder
Error: provider configuration missing
Fix: run from live/ directory
Issue 2: Docker not working
Error: Docker daemon not running
Fix: install Docker Desktop and start engine
Issue 3: EKS Kubernetes failure
Cause: private endpoint not reachable
Fix: enable public access or use VPC-connected environment
Final Takeaway

This project marked a shift from basic Terraform usage to real-world infrastructure design:

Multi-region deployments
Reusable modules
Local + cloud infrastructure
Kubernetes integration