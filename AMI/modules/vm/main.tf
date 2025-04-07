resource "azurerm_public_ip" "main" {
  count               = var.location == "public" ? 1 : 0
  name                = "${var.instance}-public-ip"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  allocation_method   = "Static"

  tags = {
    environment = "${var.instance}-ip"
  }
}


resource "azurerm_network_interface" "public" {
  count               = var.location == "public" ? 1 : 0
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  name                = "${var.instance}-nic"


  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main[0].id
  }
}

resource "azurerm_linux_virtual_machine" "public" {
  count               = var.location == "public" ? 1 : 0
  name                = "${var.instance}-machine"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password                  = "Chaithanya1812"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.public[0].id,
  ]

  os_disk {
    name                 = "${var.instance}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9_2"
    version   = "latest"
  }

}





resource "azurerm_network_interface" "private" {
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  name                = "${var.instance}-nic"


  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "public" {

  name                = "${var.instance}-machine"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password                  = "Chaithanya1812"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.private.id,
  ]

  os_disk {
    name                 = "${var.instance}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # source_image_reference {
  #   publisher = "RedHat"
  #   offer     = "RHEL"
  #   sku       = "9_2"
  #   version   = "latest"
  # }

  source_image_id = "/Subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/Providers/Microsoft.Compute/Locations/ukwest/Publishers/RedHat/ArtifactTypes/VMImage/Offers/RHEL/Skus/9_2"
}




variable "location" {}
variable "instance" {}
variable "subnet_id" {}