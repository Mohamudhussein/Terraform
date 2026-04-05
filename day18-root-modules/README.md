🚀 Day 18 – Automated Terraform Testing (Production-Ready Setup)

Infrastructure that is tested automatically is infrastructure you can trust.

📌 Overview

This project implements a complete automated testing strategy for Terraform infrastructure, covering:

✅ Unit Testing with terraform test
✅ Integration Testing with Terratest (Go)
✅ End-to-End (E2E) Testing across full stack
✅ CI/CD Pipeline with GitHub Actions
✅ Dynamic infrastructure naming to avoid collisions
✅ Automatic cleanup to prevent cloud cost leaks

The result is a fully testable, production-style infrastructure pipeline.

🏗️ Architecture
User → ALB → Target Group → Auto Scaling Group → EC2 Instances (Python App)

Infrastructure includes:

VPC with public subnets
Internet Gateway + Routing
Application Load Balancer (ALB)
Target Group with health checks
Auto Scaling Group (ASG)
EC2 instances running a Python web server
📂 Project Structure
day18-root-modules/
├── modules/
│   ├── networking/vpc/
│   └── services/webserver-cluster/
├── test/
│   ├── webserver_cluster_test.go
│   └── full_stack_e2e_test.go
├── .github/workflows/terraform-test.yml
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
🧪 Testing Strategy
🟢 Unit Tests (Fast, No Infrastructure)

Tool: terraform test
Location: module directory

Validates:

Naming conventions
Instance configuration
Ports and listeners
cd modules/services/webserver-cluster
terraform init
terraform test

✔ Runs in seconds
✔ No AWS cost
✔ Perfect for pull requests

🔵 Integration Tests (Real Infrastructure)

Tool: Terratest (Go)

Validates:

Infrastructure deploys successfully
ALB is reachable
Application returns HTTP 200
cd test
go mod tidy
go test -v -timeout 45m -run TestWebserverClusterIntegration

✔ Deploys real AWS resources
✔ Validates behavior
✔ Automatically cleans up

🔴 End-to-End Tests (Full System)

Validates:

Entire stack works together
Networking + compute + app flow
go test -v -timeout 45m -run TestFullStackEndToEnd

✔ Highest confidence
✔ Slowest + costs more
✔ Closest to production

🔁 CI/CD Pipeline

GitHub Actions Workflow

Pull Request → Unit Tests
Push to main → Integration + E2E Tests
Key Features:
Unit tests run on every PR → fast feedback
Integration tests run only on main → cost control
Uses GitHub Secrets for AWS credentials
🔐 Required GitHub Secrets

Add these in your repository:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
⚙️ How to Run Locally
1. Initialize Terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan
2. Run Unit Tests
cd modules/services/webserver-cluster
terraform test
3. Run Integration + E2E Tests
cd ../../test
go mod tidy
go test -v -timeout 45m ./...
🧠 Key Concepts Learned
🧩 Test Layers
Layer	Purpose	Speed	Cost
Unit	Validate config logic	Fast	Free
Integration	Validate deployed resources	Medium	Low
End-to-End	Validate full system behavior	Slow	Medium
⚠️ Real Challenges Solved
1. Resource Name Conflicts

Problem: AWS resources already existed
Fix: Dynamic naming using unique IDs

2. Parallel Test Failures

Problem: Tests deleting each other's resources
Fix: Removed t.Parallel()

3. ALB Not Ready

Problem: Tests failed before instances were healthy
Fix:

Added retry logic
Configured ASG wait conditions
4. Provider Errors

Problem: terraform test failed without init
Fix: Run terraform init inside module directory

🧼 Automatic Cleanup

All tests use:

defer terraform.Destroy(t, terraformOptions)

✔ Prevents resource leaks
✔ Avoids AWS billing issues
✔ Ensures safe repeated testing

🛠️ Technologies Used
Terraform ≥ 1.6
AWS (EC2, ALB, VPC, ASG)
Go (Terratest)
GitHub Actions
Python (simple web server)
📈 Why This Matters

This project demonstrates:

Infrastructure as Code best practices
Automated validation before deployment
Production-grade testing strategy
Real-world DevOps workflow