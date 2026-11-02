output "bucket_name" {
  description = "Generated name of the CloudNotes assets bucket."
  value       = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
}
