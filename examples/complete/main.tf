module "cloud_sql" {
  source = "../../"

  project_id       = "my-gcp-project"
  region           = "us-central1"
  instance_name    = "production-postgres"
  database_version = "POSTGRES_15"
  tier             = "db-custom-4-16384"

  # Storage
  disk_size         = 100
  disk_type         = "PD_SSD"
  disk_autoresize   = true
  disk_autoresize_limit = 500

  # High Availability
  availability_type = "REGIONAL"

  # Private IP
  enable_private_ip = true
  private_network   = "projects/my-gcp-project/global/networks/my-vpc"
  enable_public_ip  = false

  # Backups
  backup_enabled                 = true
  backup_start_time              = "02:00"
  backup_location                = "us"
  point_in_time_recovery_enabled = true
  transaction_log_retention_days = 7
  retained_backups               = 30

  # Maintenance
  maintenance_window_day          = 7
  maintenance_window_hour         = 3
  maintenance_window_update_track = "stable"

  # Query Insights
  insights_config = {
    query_insights_enabled  = true
    query_plans_per_minute  = 10
    query_string_length     = 4096
    record_application_tags = true
    record_client_address   = true
  }

  # Database Flags
  database_flags = {
    "log_checkpoints"       = "on"
    "log_connections"       = "on"
    "log_disconnections"    = "on"
    "log_lock_waits"        = "on"
    "max_connections"       = "200"
  }

  # Databases
  databases = {
    "app_primary" = {}
    "app_analytics" = {}
  }

  # Users
  users = {
    "app_user" = {
      password = "super-secret-password"
    }
    "readonly_user" = {
      password = "readonly-password"
    }
  }

  # Read Replicas
  read_replicas = {
    "replica-1" = {
      tier              = "db-custom-4-16384"
      availability_type = "ZONAL"
    }
    "replica-2" = {
      tier              = "db-custom-2-8192"
      availability_type = "ZONAL"
    }
  }

  deletion_protection = true

  labels = {
    environment = "production"
    team        = "database"
    cost_center = "infrastructure"
  }
}
