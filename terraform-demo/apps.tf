resource "kubernetes_namespace" "sample-alpha" {
  metadata {
    name = "sample"
    labels = {
      istio-injection = "enabled"
    }
  }

  provider = kubernetes.cluster-alpha
}

resource "kubernetes_namespace" "sample-beta" {
  metadata {
    name = "sample"
    labels = {
      istio-injection = "enabled"
    }
  }

  provider = kubernetes.cluster-beta
}

resource "kubernetes_service" "helloworld-alpha" {
  metadata {
    name = "helloworld"
    namespace = kubernetes_namespace.sample-alpha.metadata[0].name
    labels = {
      app = "helloworld"
      service = "helloworld"
    }
  }
  spec {
    port {
      port = 5000
      name = "http"
    }
    selector = {
      app = "helloworld"
    }
  }
  provider = kubernetes.cluster-alpha
}

resource "kubernetes_service" "helloworld-beta" {
  metadata {
    name = "helloworld"
    namespace = kubernetes_namespace.sample-beta.metadata[0].name
    labels = {
      app = "helloworld"
      service = "helloworld"
    }
  }
  spec {
    port {
      port = 5000
      name = "http"
    }
    selector = {
      app = "helloworld"
    }
  }
  provider = kubernetes.cluster-beta
}

resource "kubernetes_deployment" "helloworld-alpha" {
  metadata {
    name = "helloworld-v1"
    namespace = kubernetes_namespace.sample-alpha.metadata[0].name
    labels = {
      app = "helloworld"
      version = "v1"
    }
  }
  spec {
    replicas = "1"
    selector {
      match_labels = {
        app = "helloworld"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app = "helloworld"
          version = "v1"
        }
      }
      spec {
        container {
          name = "helloworld"
          image = "docker.io/istio/examples-helloworld-v1"
          resources {
            requests = {
              cpu = "100m"
            }
          }
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
  provider = kubernetes.cluster-alpha
  depends_on = [module.asm-alpha]
}

resource "kubernetes_deployment" "helloworld-beta" {
  metadata {
    name = "helloworld-v2"
    namespace = kubernetes_namespace.sample-beta.metadata[0].name
    labels = {
      app = "helloworld"
      version = "v2"
    }
  }
  spec {
    replicas = "1"
    selector {
      match_labels = {
        app = "helloworld"
        version = "v2"
      }
    }
    template {
      metadata {
        labels = {
          app = "helloworld"
          version = "v2"
        }
      }
      spec {
        container {
          name = "helloworld"
          image = "docker.io/istio/examples-helloworld-v2"
          resources {
            requests = {
              cpu = "100m"
            }
          }
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
  provider = kubernetes.cluster-beta
  depends_on = [module.asm-beta]
}
