
data "azurerm_resources" "example" {
  resource_group_name = "iteration-1"
}

output "main" {
  value = data.azurerm_resources.example
}