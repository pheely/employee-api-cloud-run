resource "google_sql_database_instance" "this" {
  name             = var.db_settings.instance_name
  database_version = var.db_settings.database_version
  region           = var.region
  root_password    = random_password.root.result

  settings {
    tier = var.db_settings.database_tier
  }
  deletion_protection = false
}

resource "google_sql_database" "this" {
  name     = var.db_settings.db_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "this" {
  name     = var.db_settings.user_name
  instance = google_sql_database_instance.this.name
  password = random_password.user.result
}
