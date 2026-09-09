output "network_name" {
  description = "Name of the CloudNotes VPC network."
  value       = module.network.network_name
}

output "subnet_ids" {
  description = "Map of subnet key (web, app, db) to its generated subnet id."
  value       = module.network.subnet_ids
}

output "app_instance_name" {
  description = "Generated name of the CloudNotes app instance."
  value       = module.compute.instance_name
}

output "app_service_account_email" {
  description = "Email identity of the CloudNotes app service account."
  value       = module.iam.app_sa_email
}

output "database_instance_name" {
  description = "Generated name of the CloudNotes managed database instance."
  value       = module.database.db_instance_name
}

output "assets_bucket_name" {
  description = "Generated name of the CloudNotes assets bucket."
  value       = module.storage.bucket_name
}
