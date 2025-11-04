data "terraform_remote_state" "base" {
  backend = "gcs"
  config = {
    bucket = var.base_state_bucket
    prefix = var.base_state_prefix
  }
}

data "google_client_config" "default" {}

data "template_file" "primary_values" {
  template = file("${path.module}/values.yaml.tftpl")

  vars = {
    app_image = var.app_image
    app_name = var.app_name
    app_hostname = var.app_hostname
    static_ip_name = google_compute_address.primary.name
    min_replicas = 3
    max_replicas = 6
  }
}

data "template_file" "secondary_values" {
  template = file("${path.module}/values.yaml.tftpl")

  vars = {
    app_image = var.app_image
    app_name = var.app_name
    app_hostname = var.app_hostname
    static_ip_name = google_compute_address.secondary.name
    min_replicas = 1
    max_replicas = 6
  }
}