# Day 14 – Working with Multiple Providers in Terraform

This project demonstrates how to use Terraform providers to deploy infrastructure across multiple AWS regions using provider aliases. It focuses on understanding how providers work, how they are installed and versioned, and how to implement multi-region deployments in a clean and scalable way.

---

## Overview

In real-world cloud environments, infrastructure rarely exists in a single region. High availability, disaster recovery, and global applications all require multi-region setups.

This project implements a simple but practical multi-region deployment using:
- Terraform provider aliases
- AWS S3 buckets in different regions
- Version-pinned providers
- Lock file consistency

---

## Architecture

- Primary S3 bucket → `us-east-1`
- Replica S3 bucket → `us-west-2`
- Terraform provider aliases manage region-specific deployments

---

## Project Structure


.
├── versions.tf
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── .gitignore
└── README.md


---

## Provider Configuration

```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Default provider (primary region)
provider "aws" {
  region = "us-east-1"
}

# Aliased provider (secondary region)
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}
Explanation
source → identifies provider registry location
version = "~> 5.0" → allows updates within version 5 but prevents breaking changes
Default provider → used automatically
Aliased provider → explicitly used for secondary region resources
Multi-Region Deployment
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "primary" {
  bucket = "multi-region-demo-primary-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "replica" {
  provider = aws.us_west
  bucket   = "multi-region-demo-replica-${random_id.suffix.hex}"
}
How It Works
The primary bucket uses the default provider (us-east-1)
The replica bucket uses the aliased provider (aws.us_west)
Terraform routes API calls based on the provider assigned to each resource
Provider Installation and Lock File

When running:

terraform init

Terraform:

Downloads the AWS provider plugin
Stores it locally in .terraform/
Records the exact version in .terraform.lock.hcl
Example Lock File
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.100.0"
  constraints = "~> 5.0"
  hashes = [
    "h1:xxxxxxxx"
  ]
}
Why This Matters
Ensures consistent environments across machines and CI/CD pipelines
Prevents unexpected breaking changes
Verifies provider integrity using hashes

This file should always be committed to version control.

Terraform Apply Output
random_id.suffix: Creation complete
aws_s3_bucket.primary: Creation complete [id=multi-region-demo-primary-d3b0f434]
aws_s3_bucket.replica: Creation complete [id=multi-region-demo-replica-d3b0f434]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:
primary_bucket = "multi-region-demo-primary-d3b0f434"
replica_bucket = "multi-region-demo-replica-d3b0f434"
What This Confirms
Resources were successfully created in two different AWS regions
Provider aliasing worked as expected
Terraform correctly handled multi-region deployment in a single configuration
Key Concepts Learned
Providers are plugins that translate Terraform into API calls
terraform init installs and locks provider versions
.terraform.lock.hcl ensures consistency and security
Provider aliases enable multi-region and multi-account deployments
Every resource must use exactly one provider
Challenges Faced
Ensuring globally unique S3 bucket names → solved using random_id
Understanding how provider aliases override default provider behavior
Avoiding region misconfiguration between resources
Multi-Account Example (Concept)
provider "aws" {
  alias  = "production"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::111111111111:role/TerraformDeployRole"
  }
}

This allows Terraform to deploy infrastructure across multiple AWS accounts by assuming IAM roles.

Why This Project Matters

This project demonstrates a foundational concept in cloud engineering:

Multi-region infrastructure is not optional — it is required for:

High availability
Disaster recovery
Global scalability

Terraform makes this possible with minimal complexity through provider aliases.

Author

Mohamud Hussein
Cloud | DevOps | Cybersecurity Engineer