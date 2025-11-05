# Enable IAM Credentials API
resource "google_project_service" "iam_credentials_api" {
  project                    = var.project_id
  service                    = "iamcredentials.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_service_account" "gke_node" {
  project      = var.project_id
  account_id   = "${var.prefix_name}-gke-node"
  display_name = "GKE Node Service Account"
}

resource "google_project_iam_member" "gke_node_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = google_service_account.gke_node.member
}

resource "google_project_iam_member" "gke_node_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = google_service_account.gke_node.member
}

resource "google_project_iam_member" "gke_node_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.gke_node.member
}