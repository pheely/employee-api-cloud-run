resource "google_service_account" "this" {
  account_id   = var.sa_name
  display_name = var.sa_display_name
}
