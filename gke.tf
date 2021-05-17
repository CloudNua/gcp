

// Configure the Google Cloud resources
resource "google_container_cluster" "primary" {
  name                     = "${local.cluster_name}"
  location                 = "europe-west1-b"
  remove_default_node_pool = true
  initial_node_count       = 1

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${local.cluster_name}-node-pool"
  location   = "europe-west1-b"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "n1-highmem-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "env-dynamic-url" {
  value = "https://${google_container_cluster.primary.endpoint}"
}
