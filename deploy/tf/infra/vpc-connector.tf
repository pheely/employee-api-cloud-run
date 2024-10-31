resource "google_vpc_access_connector" "this" {
  name          = var.vpc_con
  ip_cidr_range = var.vpc_con_cidr
  network       = "default"
}
