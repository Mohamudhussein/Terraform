 Day 17: Manual Testing of Terraform Code

This project focuses on **manual testing of Terraform-managed infrastructure**. The goal is not just to deploy resources, but to verify that they are created correctly, function as expected, remain consistent with Terraform state, and can be cleaned up safely to avoid unnecessary AWS costs.

For this day, the infrastructure is a reusable **webserver cluster** deployed to **dev** and **prod** environments using:

- Terraform modules
- AWS Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Launch Template
- Default VPC
- Default subnets
- Remote state in S3
- State locking with DynamoDB

This project is designed to support the Day 17 manual testing workflow from *Terraform: Up & Running*, Chapter 9.

---

# Project Objectives

The main objectives of this project are:

1. Build Terraform infrastructure that can be tested manually
2. Verify provisioning, correctness, and functionality
3. Compare behavior across **dev** and **prod**
4. Confirm Terraform state consistency
5. Practice regression testing after small configuration changes
6. Establish proper cleanup discipline with `terraform destroy`

---

# What This Project Deploys

Each environment deploys the following AWS resources:

- A **default VPC** data lookup
- **Default subnets** data lookup
- A security group for the **ALB**
- A security group for the **EC2 instances**
- An **Application Load Balancer**
- A **Target Group**
- An **HTTP Listener**
- A **Launch Template**
- An **Auto Scaling Group**
- EC2 instances running Apache and serving a simple HTML page

The web page shows the environment name so you can confirm whether you are testing **dev** or **prod**.

Example response:

```html
<h1>Hello from PROD</h1>
<p>Environment: prod</p>
Project Structure
day17-manual-testing/
├── README.md
├── bootstrap/
│   └── state-backend/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
├── live/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
└── modules/
    └── webserver-cluster/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── user-data.sh
Folder-by-Folder Explanation
1. bootstrap/state-backend/

This folder is used to create the Terraform backend resources that store state remotely.

Purpose

It provisions:

an S3 bucket for Terraform state
a DynamoDB table for state locking
Why this matters

Remote state is important because:

it keeps state safe outside your local machine
it allows consistency across runs
it prevents corruption from concurrent changes
it prepares you for more realistic infrastructure workflows
Files inside
main.tf

Defines:

AWS provider
random suffix generation
S3 bucket
S3 versioning
S3 encryption
DynamoDB lock table
variables.tf

Defines:

AWS region
bucket prefix
DynamoDB table name
outputs.tf

Prints:

generated S3 bucket name
lock table name
terraform.tfvars

Provides actual values for backend creation

2. modules/webserver-cluster/

This is the reusable Terraform module for the webserver cluster.

Purpose

This module contains the actual infrastructure logic and can be reused in multiple environments.

Why a module is used

Using a module helps:

avoid repeating infrastructure code
keep dev and prod consistent
make testing easier
improve maintainability
Files inside
main.tf

Defines the infrastructure resources:

default VPC lookup
default subnet lookup
AMI lookup
security groups
ALB
target group
listener
launch template
auto scaling group
variables.tf

Defines configurable inputs such as:

environment
instance type
cluster size
server text
tags
outputs.tf

Exports useful values like:

ALB DNS name
ASG name
target group ARN
subnet IDs
VPC ID
user-data.sh

Bootstrap script that:

installs Apache
creates a simple HTML page
starts the web server
3. live/dev/

This folder deploys the module in the development environment.

Purpose

It calls the reusable module with dev-specific settings.

Typical dev settings
smaller scale
lower desired capacity
cheaper testing behavior
environment tag set to dev
Files inside
backend.tf

Configures remote state path for dev, for example:

key = "day17/dev/terraform.tfstate"
main.tf

Calls the module and passes dev values such as:

environment = "dev"
desired_capacity = 1
server_text = "Hello from DEV"
variables.tf

Contains variables for the environment

terraform.tfvars

Stores actual values such as region

outputs.tf

Prints useful module outputs for the dev deployment

4. live/prod/

This folder deploys the module in the production environment.

Purpose

It calls the same module, but with production-specific values.

Typical prod settings
more instances than dev
different greeting text
environment tag set to prod
Files inside

The file roles are the same as in live/dev/, but the values are for production.

Why Default VPC and Default Subnets Were Used

For this day, the focus is on manual testing, not building custom networking from scratch.

Using the default VPC and default subnets helps because:

it reduces code complexity
it makes testing faster
it avoids spending time on networking setup
it keeps the focus on provisioning verification and functional testing

The Terraform module uses data sources to discover the default networking resources dynamically.

Example:

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
Why Unique S3 Bucket Names Are Needed

S3 bucket names are globally unique across AWS. That means your chosen bucket name cannot already be used by another AWS account anywhere in the world.

To avoid conflicts, this project uses a random_id suffix when creating the backend bucket.

Example:

resource "random_id" "suffix" {
  byte_length = 4
}

This makes it easier to create a valid bucket name like:

mohamud-day17-tf-state-a1b2c3d4
Prerequisites

Before using this project, make sure you have the following installed:

Terraform
AWS CLI
Git
A valid AWS account
AWS credentials configured locally

You can verify your tools with:

terraform version
aws --version
git --version

To confirm AWS authentication:

aws sts get-caller-identity
Step 1: Create the Backend Resources

Go to the backend bootstrap folder:

cd bootstrap/state-backend

Initialize Terraform:

terraform init

Review the plan:

terraform plan

Apply the configuration:

terraform apply

After apply completes, Terraform will output:

state_bucket_name
lock_table_name

Copy the bucket name because you will use it in both dev and prod backend configuration.

Step 2: Update the Backend Configuration

Open these files:

live/dev/backend.tf
live/prod/backend.tf

Replace:

bucket = "REPLACE_WITH_YOUR_UNIQUE_BUCKET_NAME"

with your actual S3 bucket name from the backend bootstrap output.

Do not change the DynamoDB table name unless you also changed it in the backend bootstrap folder.

Step 3: Deploy the Development Environment

Go into the dev folder:

cd live/dev

Initialize Terraform:

terraform init -reconfigure

Validate the configuration:

terraform validate

Generate an execution plan:

terraform plan

Apply the configuration:

terraform apply

After apply, Terraform will output values such as:

ALB DNS name
ASG name
target group ARN

These outputs are very important for manual testing.

Step 4: Deploy the Production Environment

Go into the prod folder:

cd live/prod

Initialize Terraform:

terraform init -reconfigure

Validate the configuration:

terraform validate

Generate a plan:

terraform plan

Apply the configuration:

terraform apply

The production environment should return an ALB DNS name that serves the production page content.

Environment Differences

This project intentionally keeps dev and prod very similar, but with a few differences so you can test environment-specific behavior.

Dev
smaller desired capacity
lower scale
text response: Hello from DEV
Prod
larger desired capacity
more instances
text response: Hello from PROD

These differences are useful for comparing behavior during manual testing.

How the Webserver Works

The EC2 instances use a user-data script to install Apache and write an HTML file.

Example behavior:

EC2 instance launches
user-data.sh runs
Apache is installed
index.html is written to /var/www/html/index.html
Apache is enabled and started
ALB routes traffic to healthy instances

This makes it easy to verify whether the infrastructure is functioning correctly.

Manual Testing Workflow for Day 17

The main purpose of this project is to support a structured manual testing process.

You should manually verify the following categories.

1. Provisioning Verification

These checks confirm that Terraform itself is working properly.

Commands
terraform init
terraform validate
terraform plan
terraform apply
What to verify
terraform init completes without errors
terraform validate returns success
terraform plan shows expected resources
terraform apply completes successfully
2. Resource Correctness

These checks confirm that AWS resources were created exactly as expected.

What to verify
ALB exists in AWS Console
ASG exists in AWS Console
target group exists
security groups exist
names match expected values
tags are correct
region is correct
security group rules match the configuration exactly
Useful checks
aws ec2 describe-security-groups
aws elbv2 describe-load-balancers
aws autoscaling describe-auto-scaling-groups
3. Functional Verification

These checks confirm the infrastructure actually works.

Get the ALB DNS name
terraform output alb_dns_name
Test the ALB response

PowerShell:

curl -UseBasicParsing http://<alb_dns_name>

Git Bash:

curl http://<alb_dns_name>
Expected behavior

You should receive HTML like:

<h1>Hello from PROD</h1>
<p>Environment: prod</p>
Check target health
aws elbv2 describe-target-health --target-group-arn <actual-target-group-arn>

Or cleaner:

aws elbv2 describe-target-health \
  --target-group-arn <actual-target-group-arn> \
  --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]" \
  --output table
What to verify
ALB DNS resolves
the app returns the expected HTML
target health is healthy
all ASG instances are healthy
4. Auto Scaling Group Replacement Test

This confirms self-healing behavior.

Steps
Find a running instance in the ASG
Stop or terminate it manually in the AWS Console
Wait a few minutes
Check whether the ASG launches a replacement
What to verify
instance count returns to desired capacity
replacement instance becomes healthy in target group
5. State Consistency Verification

These checks confirm Terraform state matches what exists in AWS.

Command
terraform plan
Expected result
No changes. Your infrastructure matches the configuration.
Why this matters

If Terraform wants to make changes immediately after apply, that may mean:

drift
missing tags
state mismatch
hidden configuration issues
6. Regression Test

This confirms that a small intentional change only affects the expected resource.

Example changes
add a tag
change server text
change description
modify a non-destructive value
Workflow
make a small change
run terraform plan
confirm only the expected change appears
run terraform apply
run terraform plan again
confirm clean state

This is a critical part of manual testing because it helps detect unexpected side effects.

Example Manual Test Cases
Test: ALB DNS resolves and returns expected response

Command:

curl http://<alb_dns_name>

Expected:

<h1>Hello from PROD</h1>
<p>Environment: prod</p>

Actual:

<h1>Hello from PROD</h1>
<p>Environment: prod</p>

Result:

PASS
Test: Target group health is healthy

Command:

aws elbv2 describe-target-health --target-group-arn <actual-arn>

Expected:

All targets report healthy

Actual:

All targets report healthy

Result:

PASS
Test: Terraform plan is clean after apply

Command:

terraform plan

Expected:

No changes. Your infrastructure matches the configuration.

Actual:

No changes. Your infrastructure matches the configuration.

Result:

PASS
Cleanup Process

Destroying infrastructure after testing is a major part of Day 17. This prevents cost leaks and confirms resources can be removed cleanly.

Always plan destroy first
terraform plan -destroy
Then destroy
terraform destroy
Post-destroy verification commands

Check EC2 instances tagged by Terraform:

aws ec2 describe-instances \
  --filters "Name=tag:ManagedBy,Values=terraform" \
  --query "Reservations[*].Instances[*].InstanceId"

Check load balancers:

aws elbv2 describe-load-balancers \
  --query "LoadBalancers[*].LoadBalancerArn"
What to verify
no project EC2 instances remain
no ALBs remain
no target groups remain
no orphaned security groups remain

If destroy fails partway, clean up manually in the AWS Console and document it.

Common Issues and Fixes
1. Module path errors

If Terraform cannot find the module, confirm the folder structure is correct and the source path matches your layout.

Expected module call from live/dev or live/prod:

source = "../../modules/webserver-cluster"
2. ALB returns unhealthy targets

Possible causes:

Apache did not install
user-data did not run correctly
security group rule is wrong
health check path is wrong

Check:

target group health
instance security group
user-data script content
3. PowerShell curl warning

PowerShell aliases curl to Invoke-WebRequest, which may show a script execution warning.

Use:

curl -UseBasicParsing http://<alb_dns_name>

or

(Invoke-WebRequest -UseBasicParsing http://<alb_dns_name>).Content
4. Bash placeholder errors

Do not run commands with placeholders like:

--target-group-arn <target-group-arn>

In bash, < > are interpreted as operators. Replace them with the real value.

Correct:

aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:...
5. S3 bucket name already taken

Bucket names must be globally unique. Use a random suffix or update the prefix.

Why This Project Fits Day 17

This project was built specifically to support the Day 17 learning outcomes:

manual testing before automation
structured verification of Terraform resources
documentation of pass/fail results
comparison of dev and prod
cleanup discipline to control AWS costs

It is simple enough to deploy and test quickly, but realistic enough to demonstrate the real value of manual infrastructure testing.

Commands Summary
Backend bootstrap
cd bootstrap/state-backend
terraform init
terraform plan
terraform apply
Dev
cd live/dev
terraform init -reconfigure
terraform validate
terraform plan
terraform apply
terraform output
terraform plan
terraform plan -destroy
terraform destroy
Prod
cd live/prod
terraform init -reconfigure
terraform validate
terraform plan
terraform apply
terraform output
terraform plan
terraform plan -destroy
terraform destroy
Functional checks
terraform output alb_dns_name
terraform output target_group_arn
curl http://<alb_dns_name>
aws elbv2 describe-target-health --target-group-arn <actual-arn>
Final Notes

This Day 17 project is about building confidence in your infrastructure.

Terraform success is not only about getting terraform apply to finish. It is about verifying that:

the right resources were created
they work correctly
Terraform state matches reality
small changes behave predictably
the environment can be cleaned up safely

That is the habit manual testing builds, and that habit is what prepares you for automated testing later.