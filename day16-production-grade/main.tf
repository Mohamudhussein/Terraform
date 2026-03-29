provider "aws" {
  region = var.aws_region
}

module "webserver_cluster" {
  source = "./modules/webserver-cluster"

  aws_region             = var.aws_region
  cluster_name           = var.cluster_name
  environment            = var.environment
  project_name           = var.project_name
  team_name              = var.team_name
  instance_type          = var.instance_type
  server_port            = var.server_port
  alb_port               = var.alb_port
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
  cpu_alarm_threshold    = var.cpu_alarm_threshold
  cpu_alarm_period       = var.cpu_alarm_period
  cpu_alarm_evaluation   = var.cpu_alarm_evaluation
  app_log_retention_days = var.app_log_retention_days
  user_data              = var.user_data
}