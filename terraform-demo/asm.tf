data "google_client_config" "default" {}

locals {
  alpha_id                    = google_container_cluster.alpha.id
  cluster_alpha_computed_name = element(split("/", local.alpha_id), length(split("/", local.alpha_id)) - 1)
  beta_id                     = google_container_cluster.beta.id
  cluster_beta_computed_name  = element(split("/", local.beta_id), length(split("/", local.beta_id)) - 1)
}

module "asm-alpha" {
  source                    = "../modules/asm"
  project_id                = var.project_id
  cluster_name              = local.cluster_alpha_computed_name
  cluster_location          = var.region
  enable_cni                = true
  multicluster_mode         = "connected"
  enable_fleet_registration = true
  providers = {
    kubernetes = kubernetes.cluster-alpha
  }
}

module "asm-beta" {
  source                    = "../modules/asm"
  project_id                = var.project_id
  cluster_name              = local.cluster_beta_computed_name
  cluster_location          = var.region
  enable_cni                = true
  multicluster_mode         = "connected"
  enable_fleet_registration = true
  providers = {
    kubernetes = kubernetes.cluster-beta
  }
}

