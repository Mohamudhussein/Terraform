provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Security group for instances"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "instance_http" {
  security_group_id = aws_security_group.instance.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "instance_out" {
  security_group_id = aws_security_group.instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_out" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

module "zero_downtime_webserver" {
  source = "../../../modules/zero-downtime-webserver"

  cluster_name               = var.cluster_name
  ami                        = data.aws_ami.amazon_linux.id
  instance_type              = var.instance_type
  server_port                = 80
  subnet_ids                 = data.aws_subnets.default.ids
  vpc_id                     = data.aws_vpc.default.id
  alb_security_group_id      = aws_security_group.alb.id
  instance_security_group_id = aws_security_group.instance.id
  min_size                   = var.min_size
  max_size                   = var.max_size
  desired_capacity           = var.desired_capacity
  blue_version               = var.blue_version
  green_version              = var.green_version
  active_environment         = var.active_environment

  common_tags = {
    Project   = "Day12-Zero-Downtime-Deployments"
    ManagedBy = "Terraform"
    Owner     = "Mohamud Hussein"
  }
}