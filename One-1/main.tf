resource "azurerm_network_security_group" "main" {
  name                = "ssg-sg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "ssh-sg"
  }
}




resource "azurerm_virtual_network" "network" {
  name                = "example-network"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.main.id
  }

  tags = {
    environment = "Production"
  }
}



resource "azurerm_subnet_network_security_group_association" "subnet-sg-assocation" {
  subnet_id                 = { for i in azurerm_virtual_network.network.subnet: i.name => i.id if i.name == "subnet1" }["subnet1"]
  network_security_group_id = azurerm_network_security_group.main.id
}



