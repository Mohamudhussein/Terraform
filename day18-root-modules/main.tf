locals {
  full_project_name = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source = "./modules/networking/vpc"

  project_name        = local.full_project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "webserver_cluster" {
  source = "./modules/services/webserver-cluster"

  project_name     = local.full_project_name
  cluster_name     = var.cluster_name
  environment      = var.environment
  instance_type    = var.instance_type
  server_port      = var.server_port
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids
}