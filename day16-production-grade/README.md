# Day 16 - Production-Grade Infrastructure

This project refactors a Terraform webserver cluster to follow production-grade practices.

## What this includes
- Remote state in S3
- State locking with DynamoDB
- Reusable Terraform module
- Clear variables and outputs
- Centralized tagging with locals
- ALB and ASG with ELB health checks
- Lifecycle rules such as create_before_destroy and prevent_destroy
- CloudWatch alarm for CPU
- CloudWatch log group with retention
- Provider version pinning
- Terratest example

## Bootstrap remote state
Run this once:

```bash
cd bootstrap
terraform init
terraform apply