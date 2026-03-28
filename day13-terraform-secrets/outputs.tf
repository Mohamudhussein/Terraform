output "db_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.example.id
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.example.endpoint
  sensitive   = true
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.example.port
}

output "db_connection_hint" {
  description = "Connection hint without exposing password"
  value       = "${local.db_username}@${aws_db_instance.example.endpoint}:${aws_db_instance.example.port}/${var.db_name}"
  sensitive   = true
}

output "secret_name_used" {
  description = "Name of the secret fetched from Secrets Manager"
  value       = data.aws_secretsmanager_secret.db_credentials.name
}