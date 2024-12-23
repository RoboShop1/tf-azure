
provider "azurerm" {
  features {}

  subscription_id = "12f9be95-f674-4dc3-8c29-d915cc4e1f8e"
}

# Persistence makes you Successful


data "azurerm_resource_group" "example" {
  name = "iteration-1"
}

output "main" {
  value = data.azurerm_resource_group.example
}


resource "azurerm_network_interface" "network-nic" {
  name                = "frontend-nic"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Network/virtualNetworks/roboshop-net/subnets/subnet-1"
    private_ip_address_allocation = "Dynamic"
  }
}