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

# Stable, friendly instance name.
resource "random_pet" "instance_name" {
  prefix    = var.instance_name_prefix
  separator = "-"
  length    = 2
}

# CloudNotes app instance representation, wired to the app subnet and SA.
resource "null_resource" "app_instance" {
  triggers = {
    name            = random_pet.instance_name.id
    machine_type    = var.machine_type
    subnet_id       = var.subnet_id
    service_account = var.sa_email
  }
}
