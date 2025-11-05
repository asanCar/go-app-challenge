# Enable Cloud DNS API
resource "google_project_service" "dns_api" {
  project                    = var.project_id
  service                    = "dns.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_dns_managed_zone" "main" {
  project  = var.project_id
  name     = "${var.prefix_name}-${var.environment}"
  dns_name = var.dns_domain

  depends_on = [google_project_service.dns_api]
}
