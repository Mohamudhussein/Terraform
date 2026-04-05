output "vpc_id" {
  description = "VPC ID created by the networking module."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs created by the networking module."
  value       = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "Autoscaling group name."
  value       = module.webserver_cluster.asg_name
}