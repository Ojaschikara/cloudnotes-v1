variable "network_name" {
  type        = string
  description = "Name of the CloudNotes VPC network."
}

variable "subnet_cidrs" {
  type        = map(string)
  description = "Map of subnet key (web, app, db) to its CIDR range."
}

variable "firewall_rules" {
  type = list(object({
    name      = string
    direction = string
    protocol  = string
    port      = number
    action    = string
  }))
  description = "List of firewall rules to apply to the CloudNotes VPC."
}
