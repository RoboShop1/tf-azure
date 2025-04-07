resource "azurerm_network_security_group" "public" {
  name                = "public-sg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all"
    priority                   = "4096"
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "public"
  }
}


resource "azurerm_network_security_group" "app" {
  name                = "app-sg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-all-public-subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all"
    priority                   = "4096"
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "public"
  }
}


resource "azurerm_network_security_group" "db" {
  name                = "db-sg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-all-app-subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.2.0/24"
   destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all"
    priority                   = "4096"
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "public"
  }
}




resource "azurerm_virtual_network" "v_net" {
  name                = "example-network"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "public"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.public.id
  }

  subnet {
    name             = "app"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.app.id

  }


  subnet {
    name             = "db"
    address_prefixes = ["10.0.3.0/24"]
    security_group   = azurerm_network_security_group.db.id
  }


  tags = {
    environment = "Dev-net"
  }
}