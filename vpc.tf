locals {
    cluster = "gitops-gke-tf"
    cluster_name = "gitops-gke-tf-${random_integer.suffix.result}"
}

resource "google_project" "google_project" {
  name       = "${local.cluster}"
  project_id = "${local.cluster_name}"
}

provider "google" {
  project = google_project.google_project.project_id
  region  = "europe-west1"
}

resource "random_integer" "suffix" {
  min = 100000
  max = 500000
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${local.cluster_name}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.cluster_name}-subnet"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}