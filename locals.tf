locals {
  default_labels = merge(var.labels, {
    managed_by = "terraform"
    module     = "cloud-sql"
  })

  is_postgres = startswith(var.database_version, "POSTGRES")
  is_mysql    = startswith(var.database_version, "MYSQL")
}
