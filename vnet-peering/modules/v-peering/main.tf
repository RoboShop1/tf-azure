data "azurerm_resource_group" "example" {
  name = "iteration-1"
}


resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "devtoprod"
  resource_group_name       = data.azurerm_resource_group.example.name
  virtual_network_name      = "dev-network"
  remote_virtual_network_id = "174524bb-3db9-4c80-a791-da8960b9c2e2"
}