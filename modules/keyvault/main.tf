data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.service_principal_tenant_id
  purge_protection_enabled    = false
  sku_name                   = "premium"
  enable_rbac_authorization = true
  soft_delete_retention_days = 7
  access_policy {
    tenant_id = var.service_principal_tenant_id
    object_id = var.service_principal_object_id

    key_permissions = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge",
  "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]

    secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  }
}


resource "azurerm_role_assignment" "kv_sp" {

  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.service_principal_object_id

}