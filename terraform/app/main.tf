# App deployment into primary cluster
resource "helm_release" "primary_app" {
  provider = helm.primary
  name = var.app_name
  namespace = var.app_namespace
  create_namespace = true
  chart = var.helm_chart_path

  values = [
    templatefile("${path.module}/values.yaml.tftpl", {
        app_image = var.app_image
        app_name = var.app_name
        app_hostname = var.app_hostname
        static_ip_name = google_compute_address.primary.name
        min_replicas = 3
        max_replicas = 6
      }
    )
  ]
}

# App deployment into secondary cluster
resource "helm_release" "secondary_app" {
  provider = helm.secondary
  name = var.app_name
  namespace = var.app_namespace
  create_namespace = true
  chart = var.helm_chart_path

  values = [
    templatefile("${path.module}/values.yaml.tftpl", {
        app_image = var.app_image
        app_name = var.app_name
        app_hostname = var.app_hostname
        static_ip_name = google_compute_address.secondary.name
        min_replicas = 1
        max_replicas = 6
      }
    )
  ]
}