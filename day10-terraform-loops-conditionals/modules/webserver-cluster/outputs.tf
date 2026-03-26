output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.this.id
}

output "instance_type_used" {
  description = "Instance type selected by conditional logic"
  value       = local.instance_type
}