# Clusters configuration

module "primary_gke" {
  source = "./modules/gke-cluster"

  project_id = var.project_id

  cluster_name = "${var.prefix_name}-primary-${var.primary_region}"
  region = var.primary_region
  min_node_count = 3
  max_node_count = 6

  network_id = google_compute_network.main.id
  subnet_id = google_compute_subnetwork.primary.id

  pods_cidr_range_name = local.pods_range_name
  services_cidr_range_name = local.services_range_name
}

module "secondary_gke" {
  source = "./modules/gke-cluster"

  project_id = var.project_id

  cluster_name = "${var.prefix_name}-secondary-${var.secondary_region}"
  region = var.secondary_region
  min_node_count = 1
  max_node_count = 6

  network_id = google_compute_network.main.id
  subnet_id = google_compute_subnetwork.secondary.id

  pods_cidr_range_name = local.pods_range_name
  services_cidr_range_name = local.services_range_name
}

