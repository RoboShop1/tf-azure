
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

data "azurerm_shared_image_version" "example" {
  name                = "latest"                # Image version
  image_name          = "rhel9-devops-practice"         # Name of the image
  gallery_name        = "LDOTrail-a8215d2e-c9a8-43ef-904d-c8b1ffb29cf7"  # Name of the gallery
  resource_group_name =  data.azurerm_resource_group.example.name # Resource group for the gallery
}

output "id" {
  value = data.azurerm_shared_image_version.example.id
}



# resource "azurerm_linux_virtual_machine" "example" {
#   name                = "example-machine"
#   resource_group_name = data.azurerm_resource_group.example.name
#   location            = data.azurerm_resource_group.example.location
#   size                = "Standard_B2s"
#   admin_username      = "adminuser"
#   admin_password      = "DevOps321321"
#   disable_password_authentication = false
#
#   network_interface_ids = [
#     azurerm_network_interface.network-nic.id
#   ]
#   source_image_id     = "subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Compute/images/rhel9-devops-practice/latest"
#
#
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#
# }