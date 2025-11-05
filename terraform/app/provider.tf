terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3"
    }
  }

  backend "gcs" {
    bucket = "terraform-states"
    prefix = "holded-challenge/app"
  }
}

provider "google" {
  project        = data.terraform_remote_state.base.outputs.project_id
  region         = data.terraform_remote_state.base.outputs.primary_region
  default_labels = local.default_labels
}

provider "helm" {
  alias = "primary"

  kubernetes = {
    host  = data.terraform_remote_state.base.outputs.primary_cluster_endpoint
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.base.outputs.primary_cluster_ca_certificate
    )
  }
}

provider "helm" {
  alias = "secondary"

  kubernetes = {
    host  = data.terraform_remote_state.base.outputs.secondary_cluster_endpoint
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.base.outputs.secondary_cluster_ca_certificate
    )
  }
}