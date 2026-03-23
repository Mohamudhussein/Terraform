output "instance_id" {
  description = "ID of the production EC2 instance."
  value       = aws_instance.web.id
}

output "instance_name" {
  description = "Name tag of the production EC2 instance."
  value       = aws_instance.web.tags.Name
}

output "subnet_id" {
  description = "Subnet used by the production EC2 instance."
  value       = aws_instance.web.subnet_id
}

output "environment" {
  description = "The current environment name."
  value       = var.environment
}