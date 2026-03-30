output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "Autoscaling group name"
  value       = aws_autoscaling_group.this.name
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "instance_security_group_id" {
  value = aws_security_group.instance.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_subnet_ids" {
  value = data.aws_subnets.default.ids
}