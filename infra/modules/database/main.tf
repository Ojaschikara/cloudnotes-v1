terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

# Unique suffix so the DB instance name doesn't collide across runs.
resource "random_id" "db_suffix" {
  byte_length = 3
}

# Managed database instance representation, placed on the private db subnet.
resource "null_resource" "database" {
  triggers = {
    name      = "${var.db_name}-${random_id.db_suffix.hex}"
    tier      = var.db_tier
    subnet_id = var.subnet_id
  }
}
