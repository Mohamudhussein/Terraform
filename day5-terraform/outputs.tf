output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.example.arn
  description = "ARN of the target group"
}

output "autoscaling_group_name" {
  value       = aws_autoscaling_group.web_asg.name
  description = "Name of the Auto Scaling Group"
}