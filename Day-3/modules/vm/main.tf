resource "azurerm_network_security_group" "main" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.sg_ports
    iterator = sg

    content {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = sg.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  # security_rule {
  #   name                       = "ssh"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "22"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  tags = {
    environment =  "${var.component}-sg"
  }
}


resource "azurerm_public_ip" "main" {
  name                = "${var.component}-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  allocation_method   = "Static"

  tags = {
    environment = "${var.component}-ip"
  }
}


resource "azurerm_network_interface" "main" {
  name                = "${var.component}-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}


resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}



resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.component}-vm"
  location                        = var.resource_group_location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_B2s"
  admin_username                  = "adminuser"
  admin_password                  = "Chaithanya1812"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Compute/galleries/customGallery/images/roboshopVM/versions/1.0.0"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}










