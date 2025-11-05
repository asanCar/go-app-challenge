resource "google_compute_network" "main" {
  name                    = "${var.prefix_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  name          = "${var.prefix_name}-primary-${var.primary_region}"
  network       = google_compute_network.main.id
  region        = var.primary_region
  ip_cidr_range = "10.10.1.0/24"

  secondary_ip_range {
    range_name    = local.pods_range_name
    ip_cidr_range = "192.168.1.0/16"
  }
  secondary_ip_range {
    range_name    = local.services_range_name
    ip_cidr_range = "10.20.1.0/20"
  }
}

resource "google_compute_subnetwork" "secondary" {
  name          = "${var.prefix_name}-secondary-${var.secondary_region}"
  network       = google_compute_network.main.id
  region        = var.primary_region
  ip_cidr_range = "10.10.2.0/24"

  secondary_ip_range {
    range_name    = local.pods_range_name
    ip_cidr_range = "192.168.2.0/16"
  }
  secondary_ip_range {
    range_name    = local.services_range_name
    ip_cidr_range = "10.20.2.0/20"
  }
}

# Firewall to allow Google's health checks against GKE nodes
resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-health-checks"
  network = google_compute_network.main.id

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }
}