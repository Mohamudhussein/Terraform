# Day 19: Adopting Infrastructure as Code in Your Team

## Current State Assessment

### How infrastructure is currently provisioned
Infrastructure is currently managed through a mix of AWS console actions, one-off CLI commands, and a small amount of Terraform used by individual engineers. This creates inconsistency because not every change is tracked in one place.

### Number of people involved and approval process
Infrastructure changes typically involve 2 to 4 people depending on the system. Approval is informal in lower environments and more careful in production, but there is no single standard workflow enforced for all changes.

### Frequency of incidents or unexpected behaviour
Manual changes introduce risk. Common issues include security settings drifting from intended values, missing documentation, and changes that are difficult to reproduce in another environment.

### Drift between documented and actual infrastructure
Yes. There is clear drift between what is documented and what exists in AWS. Some resources were created manually and are not reflected in version-controlled files.

### Secrets handling
Secrets are improving but still represent a risk area. Some credentials are managed properly through cloud-native services, while others may still be shared informally or stored in ways that are harder to audit.

## Team Readiness

### Familiarity with version control for infrastructure
The team is familiar with Git for application code, but not everyone is confident using version control for infrastructure changes, reviewing Terraform plans, or understanding state.

### Management appetite for change
There is likely support for a tooling change if it reduces incidents, improves visibility, and saves time during provisioning and troubleshooting.

### What it would take to trust automated deployments
The team will trust automation when it is introduced gradually, first on low-risk resources, with visible plan output, peer review, state locking, and a rollback path.

---

## Four-Phase IaC Adoption Plan

## Phase 1: Start with something new
The first Terraform-managed resource will be a new S3 bucket for monitoring dashboards or shared team artifacts. This avoids migration risk and gives the team a clean starting point.

### Phase 1 deliverables
- Terraform configuration for the new S3 bucket
- Remote state in S3
- DynamoDB locking enabled
- Pull request review before merge
- Team walkthrough of terraform plan output

### Success criteria
- Resource created successfully with Terraform
- Team can read plan output
- No manual console changes made to the bucket

---

## Phase 2: Import existing infrastructure
After the workflow is understood, bring selected existing resources under Terraform state.

### Import targets
- Frequently changed S3 buckets
- Security groups that caused previous issues
- IAM roles used by internal tooling

### Commands
```bash
terraform import aws_s3_bucket.existing_logs my-existing-logs-bucket
terraform import aws_security_group.existing sg-0abc123def456789