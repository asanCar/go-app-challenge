# App deployment into primary cluster
resource "helm_release" "primary_app" {
  provider = helm.primary
  name = var.app_name
  namespace = var.app_namespace
  create_namespace = true
  chart = var.helm_chart_path

  values = [
    data.template_file.primary_values.rendered
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
    data.template_file.secondary_values.rendered
  ]
}