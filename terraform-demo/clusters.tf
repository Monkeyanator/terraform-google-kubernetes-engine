provider "kubernetes" {
  host                   = "https://${google_container_cluster.alpha.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.alpha.master_auth[0].cluster_ca_certificate)
  alias                  = "cluster-alpha"
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.beta.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.beta.master_auth[0].cluster_ca_certificate)
  alias                  = "cluster-beta"
}

resource "google_container_cluster" "alpha" {
  project            = var.project_id
  name               = "cluster-alpha"
  location           = var.region
  initial_node_count = 3
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "beta" {
  project            = var.project_id
  name               = "cluster-beta"
  location           = var.region
  initial_node_count = 3
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

