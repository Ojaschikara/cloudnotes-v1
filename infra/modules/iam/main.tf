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

# App service account representation.
resource "random_pet" "app_sa" {
  prefix    = "${var.project_name}-sa"
  separator = "-"
  length    = 2
}

# Least-privilege role bindings for the app service account.
resource "null_resource" "role_binding" {
  for_each = toset(var.roles)

  triggers = {
    role   = each.key
    member = "serviceAccount:${random_pet.app_sa.id}@${var.project_name}.iam.gserviceaccount.com"
  }
}
