data "google_project" "this" {
  project_id = var.project_id
}

data "google_compute_network" "private" {
  count   = var.enable_private_ip && var.private_network != null ? 1 : 0
  project = var.project_id
  name    = var.private_network
}
