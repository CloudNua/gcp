resource "random_integer" "suffix" {
  min = 100000
  max = 500000
}

locals {
  project_id   = "gitops-gke-tf-343434"
  cluster      = "gitops-gke-tf"
  cluster_name = "gitops-gke-tf-${random_integer.suffix.result}"
}

provider "google" {
  project = local.project_id
  region  = "europe-west1"
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "3.2.2"
  project_id   = local.project_id
  network_name = "${local.cluster_name}-vpc"

  subnets = [
    {
      subnet_name           = "europe-west1-01"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = "europe-west1"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "europe-west1-02"
      subnet_ip             = "10.20.0.0/16"
      subnet_region         = "europe-west1"
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    europe-west1-01 = [
      {
        range_name    = "europe-west1-01-gke-01-pods"
        ip_cidr_range = "192.167.0.0/16"
      },
      {
        range_name    = "europe-west1-01-gke-01-services"
        ip_cidr_range = "192.168.0.0/16"
      }
    ]

    europe-west1-02 = []
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}