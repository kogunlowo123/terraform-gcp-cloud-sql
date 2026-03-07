# ---------------------------------------------------------------------------------------------------------------------
# Private Service Networking (for private IP)
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_global_address" "private_ip" {
  count = var.enable_private_ip ? 1 : 0

  project       = var.project_id
  name          = "${var.instance_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.private_network
}

resource "google_service_networking_connection" "private_vpc" {
  count = var.enable_private_ip ? 1 : 0

  network                 = var.private_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip[0].name]
}

# ---------------------------------------------------------------------------------------------------------------------
# Cloud SQL Instance
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_database_instance" "this" {
  project             = var.project_id
  name                = var.instance_name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    disk_autoresize   = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    availability_type = var.availability_type
    user_labels       = local.default_labels

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.enable_private_ip ? var.private_network : null
      require_ssl     = var.require_ssl
      allocated_ip_range = var.allocated_ip_range

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      location                       = var.backup_location
      point_in_time_recovery_enabled = local.is_postgres ? var.point_in_time_recovery_enabled : false
      transaction_log_retention_days = var.transaction_log_retention_days

      backup_retention_settings {
        retained_backups = var.retained_backups
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    insights_config {
      query_insights_enabled  = var.insights_config.query_insights_enabled
      query_plans_per_minute  = var.insights_config.query_plans_per_minute
      query_string_length     = var.insights_config.query_string_length
      record_application_tags = var.insights_config.record_application_tags
      record_client_address   = var.insights_config.record_client_address
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }
  }

  depends_on = [google_service_networking_connection.private_vpc]
}

# ---------------------------------------------------------------------------------------------------------------------
# Databases
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_database" "this" {
  for_each = var.databases

  project   = var.project_id
  instance  = google_sql_database_instance.this.name
  name      = each.key
  charset   = each.value.charset
  collation = each.value.collation
}

# ---------------------------------------------------------------------------------------------------------------------
# Users
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_user" "this" {
  for_each = var.users

  project  = var.project_id
  instance = google_sql_database_instance.this.name
  name     = each.key
  password = each.value.password
  type     = each.value.type
}

# ---------------------------------------------------------------------------------------------------------------------
# Read Replicas
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_database_instance" "read_replica" {
  for_each = var.read_replicas

  project              = var.project_id
  name                 = "${var.instance_name}-${each.key}"
  master_instance_name = google_sql_database_instance.this.name
  database_version     = var.database_version
  region               = var.region
  deletion_protection  = var.deletion_protection

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = coalesce(each.value.tier, var.tier)
    disk_size         = coalesce(each.value.disk_size, var.disk_size)
    disk_type         = coalesce(each.value.disk_type, var.disk_type)
    disk_autoresize   = var.disk_autoresize
    availability_type = each.value.availability_type
    user_labels       = local.default_labels

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.enable_private_ip ? var.private_network : null
      require_ssl     = var.require_ssl
    }
  }
}
