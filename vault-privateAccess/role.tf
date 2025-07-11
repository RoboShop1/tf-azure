resource "azuread_application" "keyvault" {
  display_name = "keyvault"
}
resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.keyvault.client_id

}

resource "azurerm_role_assignment" "role" {
  scope                = data.azurerm_key_vault.roboshop3.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.sp.object_id
}

output "sp_id" {
  value = azuread_service_principal.sp
}