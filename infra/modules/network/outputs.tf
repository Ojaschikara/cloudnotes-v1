output "network_name" {
  description = "Name of the CloudNotes VPC network."
  value       = var.network_name
}

output "subnet_ids" {
  description = "Map of subnet key (web, app, db) to its generated subnet id."
  value       = { for key, subnet in null_resource.subnets : key => subnet.id }
}

output "subnet_cidrs" {
  description = "Map of subnet key to its CIDR range."
  value       = var.subnet_cidrs
}

output "firewall_rule_names" {
  description = "Names of the firewall rules applied to the network."
  value       = [for rule in var.firewall_rules : rule.name]
}
