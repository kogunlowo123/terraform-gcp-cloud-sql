module "test" {
  source = "../"

  project_id       = "test-project-id"
  region           = "us-central1"
  instance_name    = "test-postgres-instance"
  database_version = "POSTGRES_15"
  tier             = "db-custom-2-8192"

  disk_size           = 20
  disk_type           = "PD_SSD"
  disk_autoresize     = true
  availability_type   = "REGIONAL"
  deletion_protection = false

  enable_public_ip  = true
  enable_private_ip = false
  require_ssl       = true

  authorized_networks = [
    {
      name  = "office-network"
      value = "203.0.113.0/24"
    }
  ]

  backup_enabled                 = true
  backup_start_time              = "03:00"
  point_in_time_recovery_enabled = true
  transaction_log_retention_days = 7
  retained_backups               = 14

  maintenance_window_day          = 7
  maintenance_window_hour         = 3
  maintenance_window_update_track = "stable"

  database_flags = {
    "log_checkpoints"       = "on"
    "log_connections"       = "on"
    "log_disconnections"    = "on"
    "log_min_duration_statement" = "1000"
  }

  databases = {
    app_db = {
      charset   = "UTF8"
      collation = "en_US.UTF8"
    }
    analytics_db = {}
  }

  users = {
    app_user = {
      password = "test-password-change-me"
      type     = "BUILT_IN"
    }
  }

  insights_config = {
    query_insights_enabled  = true
    query_plans_per_minute  = 10
    query_string_length     = 2048
    record_application_tags = true
    record_client_address   = true
  }

  labels = {
    environment = "test"
    managed_by  = "terraform"
  }
}
