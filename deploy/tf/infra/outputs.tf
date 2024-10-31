output "redis_host" {
  value = google_redis_instance.this.host
}

output "redis_instance" {
  value = google_redis_instance.this.name
}

output "redis_port" {
  value = google_redis_instance.this.port
}
output "root_pw_secret_id" {
  value = google_secret_manager_secret.root_pw.secret_id
}

output "root_pw_secret_version" {
  value = google_secret_manager_secret_version.root_pw.version
}

output "user_pw_secret_id" {
  value = google_secret_manager_secret.user_pw.secret_id
}

output "user_pw_secret_version" {
  value = google_secret_manager_secret_version.user_pw.version
}

output "instance_connection_name" {
  value = google_sql_database_instance.this.connection_name
}

output "vpc_connector" {
  value = google_vpc_access_connector.this.id
}

output "db_user" {
  value = google_sql_user.this.name
}

output "db_name" {
  value = google_sql_database.this.name
}

output "sa_email" {
  value = google_service_account.this.email
}

output "topic" {
  value = google_pubsub_topic.this.name
}
