variable "base_state_bucket" {
  description = "The bucket name where the base infrastructure stack's Terraform state is stored"
  type = string
  default = "terraform-states"
}

variable "base_state_prefix" {
  description = "The bucket's path where the base infrastructure stack's Terraform state is stored"
  type = string
  default = "holded-challenge/base/terraform.tfstate"
}

variable "environment" {
  description = "The environment all this resources will be deployed to (e.g. dev, int, prod)"
  type = string
  default = "dev"
}

variable "app_name" {
  description = "A name to be used when naming resources"
  type = string
  default = "my-app"
}

variable "app_namespace" {
  description = "The namespace in the GKE cluster where the app will be deployed"
  type = string
  default = "my-app"
}

variable "app_image" {
  description = "Application's Docker image to be used"
  type = string
  default = ""
}

variable "app_hostname" {
  description = "The hostname the app will be listening to"
  type = string
  default = "my-app.example.com"
}

variable "helm_chart_path" {
  description = "Path to the Helm chart"
  type = string
  default = "./charts/go-app-chart"
}