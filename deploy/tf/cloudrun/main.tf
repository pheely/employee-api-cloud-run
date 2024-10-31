resource "google_cloud_run_v2_service" "this" {
  name     = var.service_name
  location = var.region

  template {
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [data.terraform_remote_state.infra.outputs.instance_connection_name]
      }
    }

    vpc_access {
      connector = data.terraform_remote_state.infra.outputs.vpc_connector
    }

    service_account = var.sa

    containers {
      image = var.image_name

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      env {
        name  = "DB_USER"
        value = data.terraform_remote_state.infra.outputs.db_user
      }
      env {
        name = "DB_PASS"
        value_source {
          secret_key_ref {
            secret  = data.terraform_remote_state.infra.outputs.user_pw_secret_id
            version = data.terraform_remote_state.infra.outputs.user_pw_secret_version
          }
        }
      }
      env {
        name  = "DB_NAME"
        value = data.terraform_remote_state.infra.outputs.db_name
      }
      env {
        name  = "DB_PRIVATE_IP"
        value = ""
      }
      env {
        name  = "INSTANCE_CONNECTION_NAME"
        value = data.terraform_remote_state.infra.outputs.instance_connection_name
      }
      env {
        name  = "REDIS_HOST"
        value = data.terraform_remote_state.infra.outputs.redis_host
      }
      env {
        name  = "REDIS_PORT"
        value = data.terraform_remote_state.infra.outputs.redis_port
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_binding" "this" {
  project  = var.project_id
  name     = google_cloud_run_v2_service.this.name
  location = var.region
  role     = "roles/run.invoker"
  members  = [
    "serviceAccount:${data.terraform_remote_state.infra.outputs.sa_email}"
  ]
}
