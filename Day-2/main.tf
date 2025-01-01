
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

output "main_vpc" {
  value = azurerm_virtual_network.example.subnet
}



































