output "instance_name" {
  description = "Generated name of the CloudNotes app instance."
  value       = random_pet.instance_name.id
}

output "instance_id" {
  description = "Generated id of the CloudNotes app instance representation."
  value       = null_resource.app_instance.id
}
