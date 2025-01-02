resource "azurerm_resource_group" "main" {
  name     = "roboshop"
  location = "UK West"
}


resource "azurerm_virtual_network" "main" {
  name                = "roboshop-net"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "web"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "app"
    address_prefixes = ["10.0.2.0/24"]

  }
  subnet {
    name             = "db"
    address_prefixes = ["10.0.3.0/24"]

  }

  tags = {
    environment = "roboshop-net"
  }
}

