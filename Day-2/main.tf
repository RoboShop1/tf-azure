terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = "12f9be95-f674-4dc3-8c29-d915cc4e1f8e"
}

data "azurerm_resource_group" "iteration-1" {
  name = "iteration-1"
}

output "resource_group" {
  value = data.azurerm_resource_group.iteration-1
}

resource "azurerm_virtual_network" "example" {
  name                = "Roboshop-net"
  location            = data.azurerm_resource_group.iteration-1.location
  resource_group_name = data.azurerm_resource_group.iteration-1.name
  address_space       = ["10.0.0.0/16"]


  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
  }

  tags = {
    environment = "Roboshop-1"
  }
}

resource "azurerm_network_security_group" "r-net-sg" {
  name                = "r-network"
  location            = data.azurerm_resource_group.iteration-1.location
  resource_group_name = data.azurerm_resource_group.iteration-1.name


  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "r-net-sg"
  }
}

resource "azurerm_network_security_rule" "allow-http" {
  name                        = "all-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = data.azurerm_resource_group.iteration-1.name
  network_security_group_name = azurerm_network_security_group.r-net-sg.name
}






output "main_vpc" {
  value = azurerm_virtual_network.example.subnet.*.id
}



resource "azurerm_public_ip" "public_ip" {
  name                = "r-publicip"
  location            = data.azurerm_resource_group.iteration-1.location
  resource_group_name = data.azurerm_resource_group.iteration-1.name
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "rnet-nic"
  location            = data.azurerm_resource_group.iteration-1.location
  resource_group_name = data.azurerm_resource_group.iteration-1.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.example.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "sg-assocation" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.r-net-sg.id
}







resource "azurerm_linux_virtual_machine" "sample" {
  name                = "example-machine"
  location            = data.azurerm_resource_group.iteration-1.location
  resource_group_name = data.azurerm_resource_group.iteration-1.name

  size                            = "Standard_B2s"
  admin_username                  = "adminuser"
  admin_password                  = "Chaithanya1812"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  source_image_id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Compute/galleries/customGallery/images/roboshopVM/versions/1.0.0"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}

resource "null_resource" "main" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "azureuser"
      password = "Chaithanya1812"
      host     = azurerm_public_ip.public_ip.ip_address
    }

    inline = [
      "touch /tmp/c1"
    ]
  }
}
























