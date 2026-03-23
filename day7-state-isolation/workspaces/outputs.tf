/*
  outputs.tf
  -------------------------------------------------------------------
  Outputs help verify which workspace deployed which resource and can
  also be consumed by other Terraform configurations if needed.
*/

output "workspace_name" {
  description = "The active Terraform workspace used for this deployment."
  value       = terraform.workspace
}

output "instance_id" {
  description = "ID of the EC2 instance created in the active workspace."
  value       = aws_instance.web.id
}

output "instance_name" {
  description = "Name tag assigned to the EC2 instance."
  value       = aws_instance.web.tags.Name
}

output "subnet_id" {
  description = "Subnet where the EC2 instance was launched."
  value       = aws_instance.web.subnet_id
}