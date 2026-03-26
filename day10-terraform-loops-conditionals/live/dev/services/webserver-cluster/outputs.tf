output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.webserver_cluster.asg_name
}

output "instance_type_used" {
  description = "Instance type chosen by conditional logic"
  value       = module.webserver_cluster.instance_type_used
}

output "upper_user_names" {
  description = "User names transformed to uppercase using a for expression"
  value       = local.upper_user_names
}

output "map_user_departments" {
  description = "Map of IAM usernames to department names"
  value       = local.map_user_departments
}

output "set_user_arns" {
  description = "IAM user ARNs from the set-based for_each example"
  value = {
    for username, user in aws_iam_user.set_users :
    username => user.arn
  }
}

output "map_user_arns" {
  description = "IAM user ARNs from the map-based for_each example"
  value = {
    for username, user in aws_iam_user.map_users :
    username => user.arn
  }
}