module "cloud_sql" {
  source = "../../"

  project_id       = "my-gcp-project"
  region           = "us-central1"
  instance_name    = "basic-postgres"
  database_version = "POSTGRES_15"
  tier             = "db-f1-micro"

  databases = {
    "myapp" = {}
  }

  users = {
    "appuser" = {
      password = "change-me-in-production"
    }
  }

  deletion_protection = false

  labels = {
    environment = "dev"
  }
}
