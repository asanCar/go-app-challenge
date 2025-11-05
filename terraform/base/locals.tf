locals {
  default_labels = {
    Project     = var.prefix_name
    Environment = var.environment
  }

  pods_range_name     = "pods-range"
  services_range_name = "services-range"

  prometheus_chart_version = "79.1.1"

  primary_master_cidr = "10.11.0.0/28"
  secondary_master_cidr = "10.11.0.16/28"
}