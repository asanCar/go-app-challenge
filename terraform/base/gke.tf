# Enable Artifact Registry API (to pull docker images)
resource "google_project_service" "artifact_registry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Clusters configuration

module "primary_gke" {
  source = "./modules/gke-cluster"

  project_id = var.project_id

  cluster_name               = "${var.prefix_name}-primary-${var.primary_region}"
  region                     = var.primary_region
  min_node_count             = 3
  max_node_count             = 6
  node_service_account_email = google_service_account.gke_node.email

  network_id = google_compute_network.main.id
  subnet_id  = google_compute_subnetwork.primary.id

  pods_cidr_range_name     = local.pods_range_name
  services_cidr_range_name = local.services_range_name
  master_ipv4_cidr_block = local.primary_master_cidr
}

module "secondary_gke" {
  source = "./modules/gke-cluster"

  project_id = var.project_id

  cluster_name               = "${var.prefix_name}-secondary-${var.secondary_region}"
  region                     = var.secondary_region
  min_node_count             = 1
  max_node_count             = 6
  node_service_account_email = google_service_account.gke_node.email

  network_id = google_compute_network.main.id
  subnet_id  = google_compute_subnetwork.secondary.id

  pods_cidr_range_name     = local.pods_range_name
  services_cidr_range_name = local.services_range_name
  master_ipv4_cidr_block = local.secondary_master_cidr
}

