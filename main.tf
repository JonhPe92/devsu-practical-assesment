
provider "azurerm" {
  features {}
}

provider "helm" {
  
}

#-----------------------SERVICE PRINCIPAL APP REGISTRATION AND ROLE CONTRIBUTOR ROLE ASSIGMENT-----------------------------
module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name
  subscriptions_ten_id = var.subscriptions_ten_id

}

#-------------------------------KEY VAULT CREATION FOR SECRETS------------------------------------------------------------
resource "azurerm_resource_group" "rg1" {
  name     = "devsu-keys"
  location = var.location
}


module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg1.name
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

#----------------------------AKS CLUSTER CREATION FOR DESIRED ENVIRONMENT----------------------------------
module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  environment             = var.environment
  resource_prefix = var.resource_prefix
  nodes_count = var.nodes_count
  depends_on = [
    module.ServicePrincipal
  ]
}

resource "local_file" "kubeconfig" {
  depends_on   = [module.aks]
  filename     = "./kubeconfig-aks-${var.environment}"
  content      = module.aks.config
  
}



#-------------------INSTALL TRAEFIK INGRESS CONTROLLER----------------
module "traefik-ingress" {
  source = "./modules/traefik-ingress"
  aks_kubernetes_cluster_name = module.aks.cluster_name
  aks_kubernetes_cluster_rg = module.aks.cluster_rg

}


#-------------------INSTALL CERTMANAGER IN CUSTOM NAMESPACE----------------
module "certmanager" {
  source = "./modules/certmanager"
  aks_kubernetes_cluster_name = module.aks.cluster_name
  aks_kubernetes_cluster_rg = module.aks.cluster_rg

}