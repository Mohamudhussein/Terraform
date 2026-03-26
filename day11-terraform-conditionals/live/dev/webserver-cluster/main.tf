provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

data "aws_vpc" "existing" {
  count   = var.use_existing_vpc ? 1 : 0
  default = true
}

resource "aws_vpc" "new" {
  count      = var.use_existing_vpc ? 0 : 1
  cidr_block = "10.50.0.0/16"

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

locals {
  vpc_id = var.use_existing_vpc ? data.aws_vpc.existing[0].id : aws_vpc.new[0].id
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Instance security group"
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "instance_http" {
  security_group_id = aws_security_group.instance.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "instance_all_out" {
  security_group_id = aws_security_group.instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "ALB security group"
  vpc_id      = local.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

module "webserver_cluster" {
  source = "../../../modules/webserver-cluster"

  cluster_name               = var.cluster_name
  environment                = var.environment
  ami                        = data.aws_ami.amazon_linux.id
  server_port                = 80
  alb_port                   = 80
  instance_security_group_id = aws_security_group.instance.id
  alb_security_group_id      = aws_security_group.alb.id
  subnet_ids                 = data.aws_subnets.selected.ids
  enable_detailed_monitoring = var.enable_detailed_monitoring

  common_tags = {
    Project   = "Day11-Terraform-Conditionals"
    ManagedBy = "Terraform"
    Owner     = "Mohamud Hussein"
  }
}