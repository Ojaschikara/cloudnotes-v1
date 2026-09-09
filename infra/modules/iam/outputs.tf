output "app_sa_email" {
  description = "Email identity of the CloudNotes app service account."
  value       = "${random_pet.app_sa.id}@${var.project_name}.iam.gserviceaccount.com"
}

output "bound_roles" {
  description = "IAM roles bound to the app service account."
  value       = [for r in null_resource.role_binding : r.triggers.role]
}
