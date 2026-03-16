output "instance_name" {
  description = "The name of the Cloud SQL instance."
  value       = google_sql_database_instance.this.name
}

output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance."
  value       = google_sql_database_instance.this.connection_name
}

output "instance_self_link" {
  description = "The self link of the Cloud SQL instance."
  value       = google_sql_database_instance.this.self_link
}

output "instance_ip_address" {
  description = "The IP addresses of the Cloud SQL instance."
  value       = google_sql_database_instance.this.ip_address
}

output "private_ip_address" {
  description = "The private IP address of the Cloud SQL instance."
  value       = google_sql_database_instance.this.private_ip_address
}

output "public_ip_address" {
  description = "The public IP address of the Cloud SQL instance."
  value       = google_sql_database_instance.this.public_ip_address
}

output "database_names" {
  description = "The names of the databases created."
  value       = [for db in google_sql_database.this : db.name]
}

output "user_names" {
  description = "The names of the users created."
  value       = [for user in google_sql_user.this : user.name]
}

output "read_replica_names" {
  description = "Map of read replica keys to instance names."
  value       = { for k, v in google_sql_database_instance.read_replica : k => v.name }
}

output "read_replica_connection_names" {
  description = "Map of read replica keys to connection names."
  value       = { for k, v in google_sql_database_instance.read_replica : k => v.connection_name }
}
