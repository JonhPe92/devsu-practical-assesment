data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "azuread_application" "main" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "main" {
  client_id = azuread_application.main.client_id
  #app_role_assignment_required = true
  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.object_id
}


resource "azurerm_role_assignment" "main" {

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.main.id

}