module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "14.3.0"
  project_id                 = local.project_id
  name                       = "${local.cluster}-cluster"
  region                     = "europe-west1"
  zones                      = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = "europe-west1-01-gke-01-pods"
  ip_range_services          = "europe-west1-01-gke-01-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-highmem-2"
      node_locations     = "europe-west1-b,europe-west1-c"
      min_count          = 1
      max_count          = 100
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = true
      autoscaling        = true
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

output "env-dynamic-url" {
  value = "https://${module.gke.endpoint}"
  # sensitive must be true when referencing a sensitive input variable
  sensitive = true
}