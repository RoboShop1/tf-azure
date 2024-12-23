
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




resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "DevOps321321"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.network-nic.id
  ]
  source_image_id     = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/trail1/providers/Microsoft.Compute/galleries/LDOTrail/images/rhel9-devops-practice/versions/04.12.2024"


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}