data "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.aks_kubernetes_cluster_name
  resource_group_name = var.aks_kubernetes_cluster_rg

  #depends_on = [ azurerm_kubernetes_cluster.aks-cluster ]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.cluster_ca_certificate)
  }
}
provider "kubernetes" {
    host                   = data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.cluster_ca_certificate)
}

#------------CREATE CUSTOM NAME SPACE FOR THE CONTROLLER NAMED TRAEFIK---------------
resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }  
}

resource "helm_release" "traefik" {
    depends_on = [
        kubernetes_namespace.traefik
    ]

    name = "traefik"
    namespace = "traefik"

    repository = "https://helm.traefik.io/traefik"
    chart = "traefik"

    # Set Traefik as the Default Ingress Controller
    set {
        name  = "ingressClass.enabled"
        value = "true"
    }
    set {
        name  = "ingressClass.isDefaultClass"
        value = "true"
    }
    
    # Default Redirect
    set {
        name  = "ports.web.redirectTo.port"
        value = "websecure"
    }

    # Enable TLS on Websecure
    set {
        name  = "ports.websecure.tls.enabled"
        value = "true"
    }
}