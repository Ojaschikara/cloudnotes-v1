terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

# VPC representation.
resource "null_resource" "vpc" {
  triggers = {
    name = var.network_name
  }
}

# One subnet per entry in var.subnet_cidrs (web / app / db).
resource "null_resource" "subnets" {
  for_each = var.subnet_cidrs

  triggers = {
    name    = "${var.network_name}-${each.key}-subnet"
    cidr    = each.value
    network = null_resource.vpc.id
  }
}

# One firewall rule per entry in var.firewall_rules.
resource "null_resource" "firewall" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  triggers = {
    name      = each.value.name
    direction = each.value.direction
    protocol  = each.value.protocol
    port      = tostring(each.value.port)
    action    = each.value.action
    network   = null_resource.vpc.id
  }
}
