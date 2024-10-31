resource "google_redis_instance" "this" {
  name           = var.redis_name
  tier           = var.redis_tier
  memory_size_gb = var.redis_size
  region         = var.region
}
