resource "azurerm_virtual_network" "main" {
  name                = "dev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}



resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet1"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = data.azurerm_resource_group.example.name


  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet2"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = data.azurerm_resource_group.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_security_group" "dev-nsg" {
  name                = "dev-subnet-nsg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                       = "allowssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet1-nsg" {
  subnet_id                 = azurerm_subnet.subnet-1.id
  network_security_group_id = azurerm_network_security_group.dev-nsg.id
}


resource "azurerm_subnet_network_security_group_association" "subnet2-nsg" {
  subnet_id                 = azurerm_subnet.subnet-2.id
  network_security_group_id = azurerm_network_security_group.dev-nsg.id
}