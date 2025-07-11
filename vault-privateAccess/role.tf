resource "azuread_application" "keyvault" {
  display_name = "keyvault"
}
resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.keyvault.client_id

}

resource "azurerm_role_assignment" "role" {
  scope                = azurerm_key_vault.newsecret.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azuread_service_principal_password" "pass" {
  service_principal_id = azuread_service_principal.sp.id
}


output "sp_id" {
  value = azuread_service_principal.sp
}