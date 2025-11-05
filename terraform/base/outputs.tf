# Common outputs
output "primary_region" {
  description = "The region where the primary GKE cluster is deployed to"
  value       = var.primary_region
}

output "secondary_region" {
  description = "The region where the secondary GKE cluster is deployed to"
  value       = var.secondary_region
}

output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
}

# GKE outputs
output "primary_cluster_name" {
  description = "The name of the primary GKE cluster"
  value       = module.primary_gke
}

output "primary_cluster_endpoint" {
  description = "The endpoint of the primary GKE cluster"
  value       = module.primary_gke.cluster_endpoint
  sensitive   = true
}

output "primary_ca_certificate" {
  description = "The CA certificate of the primary GKE cluster"
  value       = module.primary_gke.cluster_ca_certificate
  sensitive   = true
}

output "secondary_cluster_name" {
  description = "The name of the secondary GKE cluster"
  value       = module.secondary_gke
}

output "secondary_cluster_endpoint" {
  description = "The endpoint of the secondary GKE cluster"
  value       = module.secondary_gke.cluster_endpoint
  sensitive   = true
}

output "secondary_ca_certificate" {
  description = "The CA certificate of the secondary GKE cluster"
  value       = module.secondary_gke.cluster_ca_certificate
  sensitive   = true
}

# Network outputs
output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.main.id
}

output "dns_zone_name" {
  description = "The name of the Cloud DNS zone"
  value       = google_dns_managed_zone.main.name
}
