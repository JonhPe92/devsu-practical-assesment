output "config" {
    value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  
}

output "cluster_name" {
    value = azurerm_kubernetes_cluster.aks-cluster.name
  
}

output "cluster_rg" {
    value = azurerm_kubernetes_cluster.aks-cluster.resource_group_name
  
}