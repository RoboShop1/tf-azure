data "azurerm_resource_group" "example" {
  name = "iteration-1"
}

variable "network" {}
variable "net_range" {}
variable "subnet1_range" {}
variable "subnet2_range" {}

resource "azurerm_virtual_network" "dev" {
  name                = var.network
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  address_space       = [var.net_range]

  subnet {
    name             = "subnet1"
    address_prefixes = [var.subnet1_range]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = [var.subnet2_range]
  }

  tags = {
    environment = var.network
  }
}