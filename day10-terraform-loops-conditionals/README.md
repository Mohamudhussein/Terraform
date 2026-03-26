# Day 10: Terraform Loops and Conditionals

This project is part of my 30-Day Terraform Challenge. Day 10 focuses on using Terraform loops and conditional expressions to build dynamic infrastructure that is easier to maintain, safer to scale, and more realistic for production environments.

## What this project demonstrates

This project covers the four major Terraform concepts from Day 10:

- `count`
- `for_each`
- `for expressions`
- conditional logic using the ternary operator

It also shows how to apply these concepts in a real infrastructure setup using:

- AWS Launch Templates
- Auto Scaling Groups
- Application Load Balancers
- Security Groups
- IAM Users
- locals and outputs

## Project structure

```text
day10-terraform-loops-conditionals/
├── README.md
├── modules/
│   └── webserver-cluster/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── user-data.sh
└── live/
    └── dev/
        └── services/
            └── webserver-cluster/
                ├── main.tf
                ├── variables.tf
                ├── terraform.tfvars
                ├── outputs.tf
                └── versions.tf

Features implemented
1. for_each

I used for_each in multiple places:

to create IAM users from a set
to create IAM users from a map
to create repeated security group ingress rules

This is safer than count when working with collections that may change over time because resources are keyed by name instead of list index.

2. count

I used count to make autoscaling policies optional:

when enable_autoscaling = true, Terraform creates the scale-in and scale-out policies
when enable_autoscaling = false, Terraform skips them

This is a good example of using count with a boolean toggle.

3. for expressions

I used for expressions to transform data into useful outputs:

convert IAM usernames to uppercase
build maps of usernames to departments
output IAM usernames mapped to their ARNs

This makes outputs much easier to read and use.

4. Conditional logic

I used a conditional expression to choose instance type based on environment:

production uses t2.medium
everything else uses t2.micro

This logic is centralized in a locals block so the code stays clean.

Why for_each is safer than count

A common problem with count happens when it is used with a list.

Example:

variable "user_names" {
  type    = list(string)
  default = ["alice", "bob", "charlie"]
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

If you remove alice from the list, Terraform shifts the indexes. That means bob and charlie may be destroyed and recreated even though you only removed one item.

With for_each, resources are tied to stable keys instead of positions:

variable "user_names" {
  type    = set(string)
  default = ["alice", "bob", "charlie"]
}

resource "aws_iam_user" "example" {
  for_each = var.user_names
  name     = each.value
}

Now if you remove alice, only alice is affected.

Prerequisites

Before running this project, make sure you have:

Terraform installed
AWS CLI installed and configured
an AWS account with permissions for:
EC2
ALB
Auto Scaling
IAM
VPC
How to run

From the root of the repo:

cd live/dev/services/webserver-cluster
terraform init
terraform plan
terraform apply

To destroy:

terraform destroy
Important variables
enable_autoscaling

Controls whether autoscaling policies are created.

enable_autoscaling = true
environment

Controls which instance type is used.

environment = "dev"

If set to production, the module uses a larger instance type.

Example outputs

After apply, Terraform returns outputs such as:

ALB DNS name
Auto Scaling Group name
chosen instance type
uppercase IAM usernames
username to ARN maps
Learning outcome

This project helped me understand that Terraform is not just about declaring resources one by one. With loops, conditionals, locals, and expressions, Terraform becomes a tool for building reusable and dynamic infrastructure.

Author

Mohamud Hussein
Cloud | DevOps | Cybersecurity