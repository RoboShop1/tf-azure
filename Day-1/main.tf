
provider "azurerm" {
  features {}

  subscription_id = "12f9be95-f674-4dc3-8c29-d915cc4e1f8e"
}



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
    subnet_id                     = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Network/virtualNetworks/robo-net/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}




resource "azurerm_virtual_machine" "main" {

  name                  = "sample"
  location              = data.azurerm_resource_group.example.location
  resource_group_name   = data.azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.network-nic.id]
  vm_size               = "Standard_B2s"


  delete_os_disk_on_termination = true


  storage_image_reference {
    id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Compute/galleries/LDOTrail/images/rhel9-devops-practice/versions/04.12.2024"
  }

  storage_os_disk {
    name              = "sample"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "sample"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    component = "sample"
  }
}


















