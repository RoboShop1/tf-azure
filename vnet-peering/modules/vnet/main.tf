data "azurerm_resource_group" "example" {
  name = "iteration-1"
}

variable "network" {}
variable "net_range" {}
variable "subnet1_range" {}
variable "subnet2_range" {}



resource "azurerm_network_security_group" "example" {
  name                = "${var.network}-sg"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location

  security_rule {
    name                       = "allow_all_ssh"
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
    environment = "${var.network}-sg"
  }


}

resource "azurerm_virtual_network" "dev" {
  name                = var.network
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  address_space       = [var.net_range]

  subnet {
    name             = "subnet1"
    address_prefixes = [var.subnet1_range]
    security_group   = azurerm_network_security_group.example.id
  }

  subnet {
    name             = "subnet2"
    address_prefixes = [var.subnet2_range]
  }

  tags = {
    environment = var.network
  }
}

