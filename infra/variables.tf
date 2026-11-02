variable "project_name" {
  type        = string
  description = "Logical name of the CloudNotes project, used as a prefix across all modules."
}

variable "region" {
  type        = string
  description = "Region the CloudNotes system is modeled in (representation only, no real cloud calls)."
}

# --- Network -----------------------------------------------------------

variable "network_name" {
  type        = string
  description = "Name of the CloudNotes VPC network."
  default     = "cloudnotes-network"
}

variable "subnet_cidrs" {
  type        = map(string)
  description = "CIDR ranges for the web, app, and db subnets."
  default = {
    web = "10.20.1.0/24"
    app = "10.20.2.0/24"
    db  = "10.20.3.0/24"
  }
}

variable "firewall_rules" {
  type = list(object({
    name      = string
    direction = string
    protocol  = string
    port      = number
    action    = string
  }))
  description = "Firewall rules applied to the CloudNotes VPC."
  default = [
    {
      name      = "allow-cloudnotes-app"
      direction = "INGRESS"
      protocol  = "tcp"
      port      = 3000
      action    = "ALLOW"
    },
    {
      name      = "allow-ssh"
      direction = "INGRESS"
      protocol  = "tcp"
      port      = 22
      action    = "ALLOW"
    },
    {
      name      = "deny-postgres-public"
      direction = "INGRESS"
      protocol  = "tcp"
      port      = 5432
      action    = "DENY"
    }
  ]
}

# --- Compute -------------------------------------------------------------

variable "machine_type" {
  type        = string
  description = "Machine type for the CloudNotes app instance."
  default     = "e2-micro"
}

# --- Database --------------------------------------------------------------

variable "db_name" {
  type        = string
  description = "Base name for the CloudNotes managed database instance."
  default     = "cloudnotes-db"
}

variable "db_tier" {
  type        = string
  description = "Machine/tier size for the managed database instance."
  default     = "db-f1-micro"
}

# --- Storage -------------------------------------------------------------

variable "bucket_name" {
  type        = string
  description = "Base name of the CloudNotes assets bucket."
  default     = "cloudnotes-assets"
}

# --- IAM -------------------------------------------------------------------

variable "iam_roles" {
  type        = list(string)
  description = "IAM roles bound to the CloudNotes app service account (least privilege)."
  default     = ["roles/storage.objectViewer", "roles/cloudsql.client"]
}
