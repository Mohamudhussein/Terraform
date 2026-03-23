/*
  outputs.tf
  -------------------------------------------------------------------
  Re-expose values retrieved from the dev environment state file.
*/

output "dev_instance_id" {
  description = "EC2 instance ID retrieved from the dev environment state."
  value       = data.terraform_remote_state.dev_environment.outputs.instance_id
}

output "dev_instance_name" {
  description = "EC2 instance name retrieved from the dev environment state."
  value       = data.terraform_remote_state.dev_environment.outputs.instance_name
}

output "dev_subnet_id" {
  description = "Subnet ID retrieved from the dev environment state."
  value       = data.terraform_remote_state.dev_environment.outputs.subnet_id
}