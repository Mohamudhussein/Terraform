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

locals {
  common_tags = {
    Project   = "Day10-Terraform-Loops-Conditionals"
    ManagedBy = "Terraform"
    Owner     = "Mohamud Hussein"
  }

  upper_user_names = [for name in var.iam_users_set : upper(name)]

  map_user_departments = {
    for username, details in var.iam_users_map :
    username => details.department
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Security group for EC2 instances"
  vpc_id      = data.aws_vpc.default.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.cluster_name}-instance-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "instance_rules" {
  for_each = var.web_ingress_rules

  security_group_id = aws_security_group.instance.id
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks[0]
  description       = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "instance_all_out" {
  security_group_id = aws_security_group.instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.default.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.cluster_name}-alb-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = var.alb_port
  to_port           = var.alb_port
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow inbound HTTP to ALB"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_instances" {
  security_group_id = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.instance.id
  ip_protocol = "-1"
}

resource "aws_iam_user" "set_users" {
  for_each = var.iam_users_set
  name     = each.value

  tags = merge(
    local.common_tags,
    {
      Type = "set-user"
    }
  )
}

resource "aws_iam_user" "map_users" {
  for_each = var.iam_users_map
  name     = each.key

  tags = merge(
    local.common_tags,
    {
      Department = each.value.department
      Admin      = tostring(each.value.admin)
      Type       = "map-user"
    }
  )
}

module "webserver_cluster" {
  source = "../../../../modules/webserver-cluster"

  cluster_name                = var.cluster_name
  ami                         = data.aws_ami.amazon_linux.id
  server_port                 = var.server_port
  alb_port                    = var.alb_port
  instance_security_group_id  = aws_security_group.instance.id
  subnet_ids                  = data.aws_subnets.default.ids
  alb_security_group_id       = aws_security_group.alb.id
  min_size                    = var.min_size
  max_size                    = var.max_size
  desired_capacity            = var.desired_capacity
  enable_autoscaling          = var.enable_autoscaling
  environment                 = var.environment
  common_tags                 = local.common_tags
}