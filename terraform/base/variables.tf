variable "project_id" {
  description = "The GCP project ID to be assigned to the resources"
  type        = string
}

variable "primary_region" {
  description = "The GCP region where the primary cluster will be created"
  type        = string
}

variable "secondary_region" {
  description = "The GCP region where the secondary cluster will be created"
  type        = string
}

variable "environment" {
  description = "The environment all this resources will be deployed to (e.g. dev, int, prod)"
  type = string
  default = "dev"
}

variable "prefix_name" {
  description = "A name to be used when naming resources"
  type = string
  default = "holded-challenge"
}

variable "dns_domain" {
  description = "The DNS domain to be managed by the Cloud DNS zone"
  type = string
  default = "example.com"
}