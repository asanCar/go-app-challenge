resource "google_compute_address" "primary" {
  name = "${var.app_name}-primary-ip"
  region = data.terraform_remote_state.base.outputs.primary_region
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

resource "google_compute_address" "secondary" {
  name = "${var.app_name}-secondary-ip"
  region = data.terraform_remote_state.base.outputs.secondary_region
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

# DNS Failover Routing Policy configuration
resource "google_compute_health_check" "primary" {
  name = "${var.app_name}-primary"

  http_health_check {
    port = 80
    request_path = "/healthz"
  }
}

resource "google_dns_record_set" "failover_record" {
  name = var.app_hostname
  type = "A"
  ttl = 60
  managed_zone = data.terraform_remote_state.base.outputs.dns_zone_name

  routing_policy {
    health_check = google_compute_health_check.primary.id
    primary_backup {
      primary {
        external_endpoints = [ google_compute_address.primary.address ]
      }
      backup_geo {
        location = data.terraform_remote_state.base.outputs.secondary_region
        health_checked_targets {
          external_endpoints = [ google_compute_address.secondary.address ]
        }
      }
    }
  }
}

