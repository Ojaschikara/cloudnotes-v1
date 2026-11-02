terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# Unique suffix so the bucket name is globally-unique.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Bucket representation — local_file gives plan/apply something concrete to show.
resource "local_file" "asset_bucket" {
  filename = "${path.module}/../../generated/${var.bucket_name}-${random_id.bucket_suffix.hex}.json"

  content = jsonencode({
    bucket_name = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
    purpose     = "CloudNotes static assets and uploads"
    region      = var.region
  })
}
