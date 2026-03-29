output "primary_bucket_name" {
  value = module.multi_region_app.primary_bucket_name
}

output "replica_bucket_name" {
  value = module.multi_region_app.replica_bucket_name
}