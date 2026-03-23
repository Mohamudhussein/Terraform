# Terraform Day 7 – State Isolation and Remote State Management

## Overview

This project demonstrates advanced Terraform state management techniques using:

- Workspace-based state isolation
- File-based environment isolation
- Remote state data sourcing
- S3 backend with DynamoDB state locking

The goal is to simulate real-world infrastructure management across multiple environments while ensuring safe and isolated state handling.

---

## Project Structure


day7-state-isolation/
├── workspaces/
├── environments/
│ ├── dev/
│ ├── staging/
│ └── production/
└── remote-state/


---

## Technologies Used

- Terraform (>= 1.5.0)
- AWS S3 (Remote State Storage)
- AWS DynamoDB (State Locking)
- AWS EC2 (Compute Resource)

---

## Backend Configuration

All environments use:

- **S3 bucket** for storing Terraform state
- **DynamoDB table** for state locking

```hcl
backend "s3" {
  bucket         = "mohamud-hussein-terraform-state-2026"
  key            = "path/to/statefile"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-locks"
  encrypt        = true
}
1. Workspace-Based Isolation

Single codebase used across environments.

Commands
cd workspaces
terraform init

terraform workspace new dev
terraform workspace new staging
terraform workspace new production

terraform workspace select dev
terraform apply -auto-approve

terraform workspace select staging
terraform apply -auto-approve
Key Concept
Same configuration
Different state per workspace
Environment determined dynamically using:
terraform.workspace

##2. File-Based Environment Isolation

Each environment has its own directory and backend.

Commands
cd environments/dev
terraform init
terraform apply -auto-approve

cd ../staging
terraform init
terraform apply -auto-approve

cd ../production
terraform init
terraform apply -auto-approve
Key Concept
Separate state files per environment
Stronger isolation
More production-friendly
3. Remote State Usage

Terraform configuration that reads outputs from another environment.

Example
data "terraform_remote_state" "dev_environment" {
  backend = "s3"

  config = {
    bucket = "mohamud-hussein-terraform-state-2026"
    key    = "day7/environments/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
State Locking

DynamoDB ensures:

Only one Terraform operation runs per state file
Prevents concurrent modifications
Avoids state corruption
Key Learnings
Workspaces provide lightweight environment separation
File-based layouts provide stronger isolation and clarity
Remote state enables cross-environment communication
State locking is critical for team environments
Clean Up

To avoid AWS charges:

terraform destroy -auto-approve

Run this in all environments and workspaces after testing.