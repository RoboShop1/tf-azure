
resource "azurerm_user_assigned_identity" "vault-identity" {
  name                = "vault-identity"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}

resource "azurerm_role_assignment" "vault-identity-role" {
  principal_id = azurerm_user_assigned_identity.vault-identity.principal_id
  scope        = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.KeyVault/vaults/roboshop3"
  role_definition_name = "Key Vault Secrets User"
}