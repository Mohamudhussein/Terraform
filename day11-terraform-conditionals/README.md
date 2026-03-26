# Day 11: Mastering Terraform Conditionals

This project is part of my 30-Day Terraform Challenge.  
Day 11 focused on using Terraform conditionals to build smarter, more flexible, and environment-aware infrastructure without maintaining separate codebases for development and production.

The goal of this project was to go beyond simple static Terraform and build a configuration that can change its behavior depending on inputs such as environment, monitoring preferences, and whether to use existing infrastructure or create new infrastructure.

---

## Project Objectives

This project demonstrates how to use:

- centralized conditional logic with `locals`
- the ternary operator in Terraform
- conditional resource creation with `count = condition ? 1 : 0`
- safe output references for optional resources
- input validation blocks
- an environment-aware module pattern
- a conditional data source pattern for existing vs new VPC usage

---

## Folder Structure

```text
day11-terraform-conditionals/
├── README.md
├── modules/
│   └── webserver-cluster/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── user-data.sh
└── live/
    ├── dev/
    │   └── webserver-cluster/
    │       ├── main.tf
    │       ├── variables.tf
    │       ├── terraform.tfvars
    │       ├── outputs.tf
    │       └── versions.tf
    └── prod/
        └── webserver-cluster/
            ├── main.tf
            ├── variables.tf
            ├── terraform.tfvars
            ├── outputs.tf
            └── versions.tf

Folder Explanation
modules/webserver-cluster/

This contains the reusable Terraform module.
It defines the core infrastructure logic that both development and production environments use.

Inside this module:

the Launch Template is created
the Application Load Balancer is created
the Target Group and Listener are created
the Auto Scaling Group is created
the CloudWatch alarm is conditionally created
conditional decisions are centralized in locals
live/dev/webserver-cluster/

This is the Terraform root configuration for the development environment.

It calls the reusable module and passes development-specific values such as:

environment = "dev"
smaller instance size
smaller cluster size
monitoring disabled by default
live/prod/webserver-cluster/

This is the Terraform root configuration for the production environment.

It uses the same module, but with production values such as:

environment = "production"
larger instance size
larger cluster size
monitoring enabled
Files and Their Purpose
versions.tf

Defines the Terraform version and required AWS provider version.

variables.tf

Declares input variables used by the module or root configuration.
This includes validation for the environment variable so invalid values are caught early.

main.tf

Contains the main infrastructure resources and logic.

outputs.tf

Defines outputs that Terraform prints after deployment.

terraform.tfvars

Stores the actual values passed into the configuration for each environment.

user-data.sh

Bootstraps the EC2 instances by installing Apache and writing a simple HTML page.

How the Code Flows

The code flow works like this:

1. Root environment is selected

You run Terraform from either:

live/dev/webserver-cluster
or live/prod/webserver-cluster

That root configuration becomes the entry point.

2. Provider and data sources are loaded

Terraform loads:

the AWS provider
the Amazon Linux AMI
the selected VPC
the selected subnets
3. Existing or new VPC decision is made

Using the use_existing_vpc variable:

if true, Terraform looks up the default/existing VPC
if false, Terraform creates a new VPC

This is controlled using conditional data source and resource creation.

4. Security groups are created

The root configuration creates:

instance security group
ALB security group

These are then passed into the module.

5. Module is called

The root config calls the webserver-cluster module and passes in:

environment
cluster name
subnet IDs
AMI ID
security groups
monitoring preference
common tags
6. Locals centralize decisions

Inside the module, locals determine:

whether the environment is production
which instance type to use
minimum cluster size
maximum cluster size
whether monitoring should be enabled

This avoids scattering ternary logic throughout resource blocks.

7. Resources are created based on conditions

The module creates:

Launch Template
ALB
Target Group
Listener
Auto Scaling Group

It conditionally creates:

CloudWatch alarm

The alarm uses:

count = local.enable_monitoring ? 1 : 0

If monitoring is off, the alarm is skipped.
If monitoring is on, the alarm is created.

8. Outputs are returned safely

Outputs such as alarm_arn are protected with a ternary check so Terraform does not fail when the alarm does not exist.

Conditional Logic Used
Centralized locals

The module uses a locals block like this:

is_production
instance_type
min_size
max_size
enable_monitoring

This makes the module easier to read, test, and maintain.

Conditional resource creation

Optional resources use:

count = condition ? 1 : 0

This is used for the CloudWatch alarm.

Safe conditional output reference

When a resource may not exist, outputs must use indexed access with a guard:

value = local.enable_monitoring ? aws_cloudwatch_metric_alarm.high_cpu[0].arn : null

Without this, Terraform would fail when count = 0.

Input validation

The environment variable only accepts:

dev
staging
production

This prevents bad values from being used.

Conditional data source pattern

This project supports two modes:

brownfield: use an existing VPC
greenfield: create a new VPC

This is useful because the same code can be reused in different infrastructure situations.

Where to Run Terraform From

You should not run Terraform from the module folder.

Run Terraform only from the root environment folders.

For development

Open your terminal in:

cd live/dev/webserver-cluster

Then run:

terraform init
terraform plan
terraform apply
For production

Open your terminal in:

cd live/prod/webserver-cluster

Then run:

terraform init
terraform plan
terraform apply
To destroy resources

Run from the same environment folder you deployed from:

terraform destroy
Expected Outcomes
Development environment outcome

When deployed from live/dev/webserver-cluster, the expected outputs are:

instance type: t2.micro
min size: 1
max size: 2
monitoring: false
CloudWatch alarm: not created

Example output:

alb_dns_name = "webservers-day11-dev-alb-3805435.us-east-1.elb.amazonaws.com"
instance_type_used = "t2.micro"
max_size_used = 2
min_size_used = 1
monitoring_enabled = false
vpc_id_used = "vpc-0dc6803d546314de5"
Production environment outcome

When deployed from live/prod/webserver-cluster, the expected outputs are:

instance type: t2.medium
min size: 3
max size: 10
monitoring: true
CloudWatch alarm: created

Example output:

alarm_arn = "arn:aws:cloudwatch:us-east-1:040740747647:alarm:webservers-day11-prod-high-cpu"
alb_dns_name = "webservers-day11-prod-alb-495874108.us-east-1.elb.amazonaws.com"
instance_type_used = "t2.medium"
max_size_used = 10
min_size_used = 3
monitoring_enabled = true
vpc_id_used = "vpc-0dc6803d546314de5"
Why This Project Matters

This project shows how Terraform can support multiple environments with one shared codebase.

Instead of writing separate files for development and production logic, this design uses:

variables
conditionals
locals
validation
optional resources

This leads to:

less duplication
better maintainability
cleaner code
safer infrastructure changes
Validation Example

If you set:

environment = "test"

Terraform returns:

Environment must be dev, staging, or production.

This helps catch mistakes before deployment.

Key Learning Outcomes

From this project, I learned:

how to centralize conditional logic with locals
how to create optional resources safely using count
how to reference conditional resources without causing index errors
how to use validation to protect module inputs
how to build one module that behaves differently across environments
how to support both existing and newly created infrastructure in the same configuration
Author

Mohamud Hussein
Cloud | DevOps | Cybersecurit