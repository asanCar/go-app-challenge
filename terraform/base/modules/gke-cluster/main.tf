# Enable GKE API
resource "google_project_service" "gke_api" {
  project                    = var.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_container_cluster" "cluster" {
  project = var.project_id
  name     = var.cluster_name
  location = var.region

  network    = var.network_id
  subnetwork = var.subnet_id

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_cidr_range_name
    services_secondary_range_name = var.services_cidr_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Default node_pool
  initial_node_count       = 1
  remove_default_node_pool = true

  # Enable Gateway API
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  depends_on = [
    google_project_service.gke_api
  ]
}

resource "google_container_node_pool" "main_pool" {
  project = var.project_id
  name       = "${var.cluster_name}-main-pool"
  location   = var.region
  cluster    = google_container_cluster.cluster.id
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_count = 1
  node_config {
    machine_type = var.node_type
    # GCP permissions to be granted to nodes
    service_account = var.node_service_account_email
  }
}
