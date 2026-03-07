variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for Cloud SQL instances"
  type        = string
  default     = "us-central1"
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "The database version (e.g., POSTGRES_15, MYSQL_8_0)"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "The machine tier for the instance"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "The disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "disk_autoresize" {
  description = "Enable disk autoresize"
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "Maximum disk size in GB for autoresize"
  type        = number
  default     = 0
}

variable "availability_type" {
  description = "Availability type (REGIONAL for HA, ZONAL for single zone)"
  type        = string
  default     = "ZONAL"
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "enable_private_ip" {
  description = "Enable private IP for the instance"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "VPC network self link for private IP"
  type        = string
  default     = null
}

variable "allocated_ip_range" {
  description = "Allocated IP range for private services access"
  type        = string
  default     = null
}

variable "enable_public_ip" {
  description = "Enable public IP for the instance"
  type        = bool
  default     = true
}

variable "authorized_networks" {
  description = "List of authorized networks for public access"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "require_ssl" {
  description = "Require SSL connections"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Start time for automated backups (HH:MM format)"
  type        = string
  default     = "03:00"
}

variable "backup_location" {
  description = "Location for backup storage"
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

variable "transaction_log_retention_days" {
  description = "Number of days to retain transaction logs"
  type        = number
  default     = 7
}

variable "retained_backups" {
  description = "Number of backups to retain"
  type        = number
  default     = 7
}

variable "maintenance_window_day" {
  description = "Day of week for maintenance window (1=Monday, 7=Sunday)"
  type        = number
  default     = 7
}

variable "maintenance_window_hour" {
  description = "Hour of day for maintenance window (0-23)"
  type        = number
  default     = 3
}

variable "maintenance_window_update_track" {
  description = "Update track for maintenance (canary or stable)"
  type        = string
  default     = "stable"
}

variable "database_flags" {
  description = "Map of database flags to set"
  type        = map(string)
  default     = {}
}

variable "databases" {
  description = "Map of databases to create"
  type = map(object({
    charset   = optional(string, null)
    collation = optional(string, null)
  }))
  default = {}
}

variable "users" {
  description = "Map of database users to create"
  type = map(object({
    password = optional(string, null)
    type     = optional(string, "BUILT_IN")
  }))
  default = {}
}

variable "read_replicas" {
  description = "Map of read replicas to create"
  type = map(object({
    tier              = optional(string, null)
    zone              = optional(string, null)
    disk_size         = optional(number, null)
    disk_type         = optional(string, null)
    availability_type = optional(string, "ZONAL")
  }))
  default = {}
}

variable "insights_config" {
  description = "Query Insights configuration"
  type = object({
    query_insights_enabled  = optional(bool, false)
    query_plans_per_minute  = optional(number, 5)
    query_string_length     = optional(number, 1024)
    record_application_tags = optional(bool, true)
    record_client_address   = optional(bool, true)
  })
  default = {}
}

variable "labels" {
  description = "Labels to apply to the instance"
  type        = map(string)
  default     = {}
}
