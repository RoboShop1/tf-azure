data "azurerm_key_vault" "keyvault" {
  name                = "roboshop3"
  resource_group_name = data.azurerm_resource_group.example.name
}


output "keyvault" {
  value = data.azurerm_key_vault.keyvault
}

resource "azurerm_user_assigned_identity" "example" {
  location            = data.azurerm_resource_group.example.location
  name                = "identity1"
  resource_group_name = data.azurerm_resource_group.example.name
}

# resource "azurerm_role_assignment" "role-assignment" {
#   name                 = "sample-assignment"
#   scope                = data.azurerm_key_vault.keyvault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.example.client_id
# }



resource "azuread_application" "example" {
  display_name = "example"
}

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_resource_group.example.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.object_id
}
