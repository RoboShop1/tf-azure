data "azurerm_resource_group" "example" {
  name = "iteration-1"
}


variable "instance" {}
variable "subnet_id" {}

resource "azurerm_public_ip" "main" {
  name                = "${var.instance}-public-ip"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  allocation_method   = "Static"

  tags = {
    environment = "${var.instance}-ip"
  }
}


resource "azurerm_network_interface" "public" {
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  name                = "${var.instance}-nic"


  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}



resource "azurerm_linux_virtual_machine" "public" {
  name                = "${var.instance}-machine"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "Chaithanya1812"
  disable_password_authentication = false

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9_2"
    version   = "latest"
  }

  # source_image_id = "/Subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/Providers/Microsoft.Compute/Locations/ukwest/Publishers/RedHat/ArtifactTypes/VMImage/Offers/RHEL/Skus/9_2"
  network_interface_ids = [
    azurerm_network_interface.public.id,
  ]

  os_disk {
    name                 = "${var.instance}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}