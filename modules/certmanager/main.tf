
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



#----------------------CREATE CUSTOM NAME SPACE FOR CERTMANAGER
resource "kubernetes_namespace" "certmanager" {
    metadata {
        name = "certmanager"
    }  
}

resource "helm_release" "certmanager" {

    depends_on = [
        kubernetes_namespace.certmanager
    ]

    name = "certmanager"
    namespace = "certmanager"

    repository = "https://charts.jetstack.io"
    chart = "cert-manager"

    # Install Kubernetes CRDs
    set {
        name  = "installCRDs"
        value = "true"
    }    
}