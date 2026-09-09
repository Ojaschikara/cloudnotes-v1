output "db_instance_name" {
  description = "Generated name of the CloudNotes database instance."
  value       = "${var.db_name}-${random_id.db_suffix.hex}"
}

output "db_instance_id" {
  description = "Generated id of the CloudNotes database instance representation."
  value       = null_resource.database.id
}
