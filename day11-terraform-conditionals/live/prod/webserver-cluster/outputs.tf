output "vpc_id_used" {
  value = local.vpc_id
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}

output "instance_type_used" {
  value = module.webserver_cluster.instance_type_used
}

output "min_size_used" {
  value = module.webserver_cluster.min_size_used
}

output "max_size_used" {
  value = module.webserver_cluster.max_size_used
}

output "monitoring_enabled" {
  value = module.webserver_cluster.monitoring_enabled
}

output "alarm_arn" {
  value = module.webserver_cluster.alarm_arn
}