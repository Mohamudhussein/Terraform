output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.web.dns_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.web.arn
}

output "autoscaling_group_name" {
  description = "Autoscaling group name"
  value       = aws_autoscaling_group.web.name
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.web.id
}

output "app_version" {
  description = "Current deployed application version"
  value       = local.app_version
}