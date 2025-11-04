locals {
  default_labels = {
    Project = var.prefix_name
    Environment = var.environment
  }

  pods_range_name = "pods-range"
  services_range_name = "services-range"
}