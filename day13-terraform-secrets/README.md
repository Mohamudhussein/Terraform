# Day 13 – Managing Sensitive Data Securely in Terraform

This project demonstrates how to securely manage secrets in Terraform using AWS Secrets Manager, sensitive values, and a protected remote state backend.

## Overview

In real-world infrastructure, secrets such as database credentials must never be:
- Hardcoded in `.tf` files
- Stored in variable defaults
- Exposed in Terraform state without protection

This project implements a secure pattern that prevents all three major secret leak paths.

---

## Architecture

- AWS Secrets Manager → stores database credentials
- Terraform Data Sources → retrieves secrets at runtime
- RDS MySQL Instance → consumes secrets securely
- S3 Backend → encrypted remote state storage
- DynamoDB → state locking

---

## Project Structure


.
├── backend.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── .gitignore
└── README.md


---

## Secrets Management Approach

Secrets are created manually in AWS Secrets Manager:

```bash
aws secretsmanager create-secret \
  --name "dev/db/credentials" \
  --secret-string '{"username":"dbadmin","password":"StrongPass123!"}'

Terraform retrieves the secret dynamically:

data "aws_secretsmanager_secret" "db_credentials" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )
}

The secret is never hardcoded and never stored in .tf files.

Security Practices Implemented
1. No Hardcoded Secrets

Credentials are retrieved dynamically at runtime.

2. No Secrets in Variables

No sensitive values are stored in variables.tf defaults.

3. Sensitive Output Handling
output "db_endpoint" {
  value     = aws_db_instance.example.endpoint
  sensitive = true
}

Terraform hides values in CLI output:

(sensitive value)
4. Secure Remote State
backend "s3" {
  bucket         = "mohamud-hussein-terraform-state-2026"
  key            = "day13/secrets/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-locks"
  encrypt        = true
}

State protection includes:

Encryption enabled
Versioning enabled
Restricted IAM access
DynamoDB locking
The Three Secret Leak Paths
Leak 1 – Hardcoded Secrets
password = "super-secret"

Fixed by using Secrets Manager.

Leak 2 – Variable Defaults
default = "super-secret"

Fixed by removing defaults and marking sensitive variables.

Leak 3 – State File Exposure

Even secure configurations store secrets in state.

Mitigation:

Remote backend
Encryption
Access control
Key Learnings
sensitive = true only hides values from output, not state
Secrets Manager integrates easily with Terraform
JSON formatting must be exact when using jsondecode
Secure state management is mandatory in production
Challenges Faced
Secret recreation failed due to scheduled deletion
Incorrect JSON format caused jsondecode errors
PowerShell quoting issues corrupted secret values
Outcome

A fully functional, secure Terraform deployment that:

Uses AWS Secrets Manager correctly
Prevents secret exposure in code
Applies production-level state security practices
Author

Mohamud Hussein
Cloud | DevOps | Cybersecurity