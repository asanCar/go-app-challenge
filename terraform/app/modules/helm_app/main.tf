resource "kubernetes_namespace" "main" {
  metadata {
    name = var.app_namespace
    labels = local.default_labels
  }
}

resource "helm_release" "app_release" {
  name = var.app_name
  namespace = kubernetes_namespace.main.metadata[0].name
  chart = var.helm_chart_path

  values = [
    var.helm_values_yaml
  ]
}