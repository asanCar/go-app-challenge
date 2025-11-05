# Enable Compute API (for NAT and Routers)
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

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

resource "google_compute_router" "primary" {
  name = "${var.prefix_name}-primary"
  region = var.primary_region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "primary" {
  name = "${var.prefix_name}-primary"
  router = google_compute_router.primary.name
  region = var.primary_region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.primary.id
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}

resource "google_compute_router" "secondary" {
  name = "${var.prefix_name}-secondary"
  region = var.secondary_region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "secondary" {
  name = "${var.prefix_name}-secondary"
  router = google_compute_router.secondary.name
  region = var.secondary_region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.secondary.id
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
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