provider "aws" {
  region = var.aws_region
}

# Get available availability zones
data "aws_availability_zones" "available" {}

# Get the default VPC automatically
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get the latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Security group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP traffic from the internet to the ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# Security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  name        = "instance-security-group"
  description = "Allow HTTP only from the ALB and SSH from anywhere"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH from anywhere for testing"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
  }
}

# Launch template for EC2 instances
resource "aws_launch_template" "web" {
  name_prefix   = "web-launch-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Hello from Terraform ASG instance</h1>" > /var/www/html/index.html
    echo "<p>Hostname: $(hostname)</p>" >> /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-asg-instance"
    }
  }
}

# Application Load Balancer
resource "aws_lb" "example" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "terraform-alb"
  }
}

# Target group for the ALB
resource "aws_lb_target_group" "example" {
  name     = "terraform-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "terraform-target-group"
  }
}

# Listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name                = "terraform-web-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.example.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraform-asg-web"
    propagate_at_launch = true
  }
}