# ---------------------------------------------------------------------------
# ROOT — composes the full CloudNotes system from five modules:
# network, iam, storage, database, compute. Each module is generic; all
# environment-specific values are declared as root variables (variables.tf)
# and passed in here, and one module's outputs feed another's inputs.
# ---------------------------------------------------------------------------

module "network" {
  source = "./modules/network"

  network_name   = var.network_name
  subnet_cidrs   = var.subnet_cidrs
  firewall_rules = var.firewall_rules
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  roles        = var.iam_roles
}

module "storage" {
  source = "./modules/storage"

  bucket_name = var.bucket_name
  region      = var.region
}

module "database" {
  source = "./modules/database"

  db_name   = var.db_name
  db_tier   = var.db_tier
  subnet_id = module.network.subnet_ids["db"] # wired from network module
}

module "compute" {
  source = "./modules/compute"

  instance_name_prefix = "${var.project_name}-vm"
  machine_type          = var.machine_type
  subnet_id             = module.network.subnet_ids["app"]  # wired from network module
  sa_email              = module.iam.app_sa_email           # wired from iam module
}
