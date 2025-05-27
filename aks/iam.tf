
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


resource "azurerm_federated_identity_credential" "example" {
  name                = "my-vault-credential"
  resource_group_name = data.azurerm_resource_group.example.name
  parent_id           = "242f2887-a31c-43ff-a162-ee21c34a91fa"
  issuer              = azurerm_kubernetes_cluster.example.oidc_issuer_url
  subject             = "system:serviceaccount:default:vault"
  audience            = ["api://AzureADTokenExchange"]
}