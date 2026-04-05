output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "Autoscaling group name."
  value       = aws_autoscaling_group.this.name
}