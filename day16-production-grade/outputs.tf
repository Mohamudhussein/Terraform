output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.webserver_cluster.asg_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for infrastructure alerts"
  value       = module.webserver_cluster.sns_topic_arn
}