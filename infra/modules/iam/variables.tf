variable "project_name" {
  type        = string
  description = "Logical project name, used to build the app service account identity."
}

variable "roles" {
  type        = list(string)
  description = "List of IAM roles bound to the CloudNotes app service account (least privilege)."
  default     = ["roles/storage.objectViewer", "roles/cloudsql.client"]
}
