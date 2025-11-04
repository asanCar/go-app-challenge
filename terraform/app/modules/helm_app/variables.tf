variable "app_name" {
  description = "The name of the application"
  type = string
}

variable "app_namespace" {
  description = "The Kubernetes namespace to deploy"
  type = string
  default = "default"
}

variable "helm_chart_path" {
  description = "Path to the Helm chart"
  type = string
}

variable "helm_values_yaml" {
  description = "The YAML values file content as string"
  type = string
  default = ""
}