Day 20 — Terraform Workflow Deployment (Beginner-Friendly Guide)
📌 What This Project Does

This project creates a simple web server system on AWS using Terraform.

When you open the link (ALB DNS), you will see:

Application version: v3

That means your infrastructure and app were deployed successfully.

🧠 What You Are Learning Here

This is NOT just about Terraform.

You are learning how engineers actually deploy systems:

Write code
Test changes
Review changes
Deploy safely

This is called a workflow.

📁 Project Structure (Very Simple)
day20-workflow-deployment/
│
├── main.tf          → Main infrastructure code
├── variables.tf     → Input settings
├── outputs.tf       → What Terraform shows after deploy
├── userdata.sh      → Script that runs on the server
├── .gitignore       → Files Git should ignore
│
├── tests/
│   └── webserver.tftest.hcl → Terraform test
│
└── .github/
    └── workflows/
        └── terraform.yml → CI automation
🔍 What Each File Does (Plain English)
main.tf

This is the brain of your project.

It creates:

Load Balancer (ALB)
EC2 servers
Auto Scaling Group
Security Groups

👉 This is where AWS resources are defined.

variables.tf

This is where we define settings like:

instance type (t2.micro)
number of servers
environment (dev)

👉 Think of this like “options” for your system.

outputs.tf

This shows useful results after deployment:

Example:

alb_dns_name

👉 This is the link you open in your browser.

userdata.sh

This is what runs inside the server when it starts.

It:

installs a web server
creates a simple webpage
shows the app version

👉 This is what makes your server actually DO something.

terraform.yml

This runs automatically when you push code.

It checks:

formatting
errors
tests

👉 This prevents broken code from going to production.

tests/webserver.tftest.hcl

This tests your Terraform code.

👉 Makes sure your infrastructure is valid.

⚙️ How Everything Works (Simple Flow)
Step 1 — Write Code

You define infrastructure in main.tf.

Step 2 — Preview Changes
terraform plan -out=day20.tfplan

👉 This shows what will happen BEFORE it happens.

Step 3 — Deploy
terraform apply day20.tfplan

👉 This actually creates your infrastructure.

Step 4 — Verify

Open:

http://<your-alb-dns>

👉 You should see:

Application version: v3
☁️ Why We Used Terraform Cloud

Instead of running everything on your laptop:

👉 Terraform runs in the cloud (HCP Terraform)

Benefits:

safer (no secrets on your laptop)
shared across team
logs everything
stores state securely
🔐 How Credentials Work (Important)

We DO NOT put secrets in code.

Instead, we use:

Workspace Variables in Terraform Cloud

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

👉 Keeps your project secure.

🔄 Real Engineering Workflow (Day 20 Lesson)

This is what you simulated:

Create branch
Make change
Run plan
Open PR
Run tests
Merge
Deploy

👉 This is how real companies work.

🧪 Example Commands
terraform init
terraform validate
terraform plan -out=day20.tfplan
terraform apply day20.tfplan
✅ Final Result
Apply complete! Resources: 8 added

Output:

alb_dns_name = webserver-cluster-dev-alb-89703489.us-east-1.elb.amazonaws.com
app_version = v3
🎯 Why This Matters

You didn’t just:

write Terraform

You learned:

safe deployment
cloud automation
real DevOps workflow

👉 This is production-level thinking

🧩 Simple Way to Remember

Think of Terraform like this:

plan = preview
apply = execute
cloud = control center