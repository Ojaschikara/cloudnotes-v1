variable "db_name" {
  type        = string
  description = "Base name for the CloudNotes managed database instance."
}

variable "db_tier" {
  type        = string
  description = "Machine/tier size for the managed database instance."
}

variable "subnet_id" {
  type        = string
  description = "ID of the private db subnet (from the network module) the database sits on."
}
