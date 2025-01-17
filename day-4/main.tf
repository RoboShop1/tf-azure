data "azurerm_resource_group" "main" {
  name = "iteration-1"
}

output "location" {
  value = data.azurerm_resource_group.main.location
}

output "name" {
  value = data.azurerm_resource_group.main.name
}
