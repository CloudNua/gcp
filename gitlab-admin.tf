data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  token                  = data.google_client_config.default.access_token
  load_config_file       = false
}

resource "kubernetes_service_account" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

data "kubernetes_secret" "gitlab-admin-token" {
  metadata {
    name      = kubernetes_service_account.gitlab-admin.default_secret_name
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "gitlab-admin" {
  metadata {
    name = "gitlab-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}
