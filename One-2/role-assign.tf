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


