data "azurerm_resource_group" "example" {
  name = "iteration-1"
}

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "B2"
}