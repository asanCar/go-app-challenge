terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.7"
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