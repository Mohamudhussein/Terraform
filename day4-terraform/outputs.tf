output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "availability_zones" {
  description = "Availability zones returned by the data source"
  value       = data.aws_availability_zones.all.names
}