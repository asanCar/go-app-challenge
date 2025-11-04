resource "helm_release" "prometheus_primary" {
  provider = helm.primary

  name = "prometheus"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  version = local.prometheus_chart_version
}

resource "helm_release" "prometheus_secondary" {
  provider = helm.secondary

  name = "prometheus"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  version = local.prometheus_chart_version
}