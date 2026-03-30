output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  value = module.webserver_cluster.asg_name
}

output "target_group_arn" {
  value = module.webserver_cluster.target_group_arn
}