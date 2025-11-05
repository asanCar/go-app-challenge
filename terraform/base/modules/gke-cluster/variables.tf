variable "project_id" {
  description = "The GCP project ID to be assigned to the resources"
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "The name for the GKE cluster"
}

variable "region" {
  type        = string
  description = "GCP region where resources are allocated"
}

variable "network_id" {
  description = "The ID of the VPC network where the cluster will be created"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the VPC subnet where the cluster will be created"
  type        = string
}

variable "pods_cidr_range_name" {
  type        = string
  description = "The secondary subnet's CIDR name for the GKE Pods"
}

variable "services_cidr_range_name" {
  type        = string
  description = "The secondary subnet's CIDR name gor the GKE Services"
}

variable "min_node_count" {
  type        = number
  description = "The minimum number of nodes in the autoscaling node pool"
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "The maximum number of nodes in the autoscaling node pool"
  default     = 3
}

variable "node_type" {
  type        = string
  description = "Machine type to be used in the webapps node pool"
  default     = "e2-micro"
}

variable "node_service_account_email" {
  description = "The email of the IAM Service Account for the GKE nodes"
  type        = string
}