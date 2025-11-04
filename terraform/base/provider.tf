terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.7"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3"
    }
  }

  backend "gcs" {
    bucket = "terraform-states"
    prefix = "holded-challenge/base" # TODO: parametrize in CICD
  }
}

# Authenticate with:  gcloud auth application-default login
provider "google" {
  project = var.project_id
  region  = var.primary_region
  default_labels = local.default_labels
}

provider "helm" {
  alias = "primary"

  kubernetes = {
    host = module.primary_gke.primary_cluster_endpoint
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
    module.primary_gke.cluster_ca_certificate
    )
  }
}

provider "helm" {
  alias = "secondary"

  kubernetes = {
    host = module.secondary_gke.secondary_cluster_endpoint
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
    module.secondary_gke.cluster_ca_certificate
    )
  }
}