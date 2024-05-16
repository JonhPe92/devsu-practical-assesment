# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}
 
resource "azurerm_resource_group" "aks-rg" {
  name     = "${var.resource_prefix}_${var.environment}_rg"
  location = var.location

}
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = "${var.resource_prefix}-${var.environment}-aks-cluster"
  location              = var.location
  resource_group_name   = azurerm_resource_group.aks-rg.name
  dns_prefix            = "${var.resource_prefix}-${var.environment}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_prefix}-${var.environment}-nrg"
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_B2s"
    node_count = var.nodes_count
    node_labels = {
      "environment"      = var.environment

     } 
   tags = {
      "environment"      = var.environment
   } 
  }

  service_principal  {
    client_id = var.client_id
    client_secret = var.client_secret
  }



  linux_profile {
    admin_username = "azureuser"
    ssh_key {
        key_data = file(var.ssh_public_key)
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    
  }