variable "instance_name_prefix" {
  type        = string
  description = "Prefix used to generate the CloudNotes app instance name."
}

variable "machine_type" {
  type        = string
  description = "Machine type for the CloudNotes app instance."
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet (from the network module) the app instance is placed in."
}

variable "sa_email" {
  type        = string
  description = "Service account email (from the iam module) attached to the app instance."
}
