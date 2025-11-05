data "terraform_remote_state" "base" {
  backend = "gcs"
  config = {
    bucket = var.base_state_bucket
    prefix = var.base_state_prefix
  }
}

data "google_client_config" "default" {}
