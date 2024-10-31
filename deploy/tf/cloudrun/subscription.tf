resource "google_pubsub_subscription" "this" {
  name  = var.sub_name
  topic = data.terraform_remote_state.infra.outputs.topic

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = "${google_cloud_run_v2_service.this.uri}${var.push_path}"

    attributes = {
      x-goog-version = "v1"
    }

    oidc_token {
      service_account_email = data.terraform_remote_state.infra.outputs.sa_email
    }
  }
}

