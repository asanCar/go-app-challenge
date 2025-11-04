module "primary_app" {
  source = "./modules/helm_app"

  providers = {
    kubernetes = kubernetes.primary
    helm = helm.primary
  }

  app_name = var.app_name
  app_namespace = var.app_namespace
  helm_chart_path = var.helm_chart_path
  helm_values_yaml = data.template_file.primary_values.rendered
}

module "secondary_app" {
  source = "./modules/helm_app"

  providers = {
    kubernetes = kubernetes.secondary
    helm = helm.secondary
  }

  app_name = var.app_name
  app_namespace = var.app_namespace
  helm_chart_path = var.helm_chart_path
  helm_values_yaml = data.template_file.secondary_values.rendered
}