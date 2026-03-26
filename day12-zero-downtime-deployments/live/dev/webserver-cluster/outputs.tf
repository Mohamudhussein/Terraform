output "alb_dns_name" {
  value = module.zero_downtime_webserver.alb_dns_name
}

output "active_environment" {
  value = module.zero_downtime_webserver.active_environment
}

output "blue_asg_name" {
  value = module.zero_downtime_webserver.blue_asg_name
}

output "green_asg_name" {
  value = module.zero_downtime_webserver.green_asg_name
}