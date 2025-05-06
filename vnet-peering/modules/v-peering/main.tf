data "azurerm_resource_group" "example" {
  name = "iteration-1"
}


resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "devtoprod"
  resource_group_name       = data.azurerm_resource_group.example.name
  virtual_network_name      = "dev-network"
  remote_virtual_network_id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Network/virtualNetworks/prod-network"
}