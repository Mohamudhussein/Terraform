output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "instance_type_used" {
  value = local.instance_type
}

output "min_size_used" {
  value = local.min_size
}

output "max_size_used" {
  value = local.max_size
}

output "monitoring_enabled" {
  value = local.enable_monitoring
}

output "alarm_arn" {
  value = local.enable_monitoring ? aws_cloudwatch_metric_alarm.high_cpu[0].arn : null
}