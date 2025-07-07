
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

  # security_rule {
  #   name                       = "allow-http"
  #   priority                   = 120
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "80"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }



  security_rule {
    name                       = "allow-http"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["205.254.168.171/32"]
    source_port_range          = "*"
    destination_port_range     = "80"
    #source_address_prefix      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.main.id]
  }

  tags = {
    environment = "ssh-sg"
  }
}


resource "azurerm_application_security_group" "main" {
  name                = "tf-http"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  tags = {
    Hello = "World"
  }
}


resource "azurerm_network_interface_application_security_group_association" "aasg" {
  network_interface_id          = azurerm_network_interface.net.id
  application_security_group_id = azurerm_application_security_group.main.id
}


#
# resource "azurerm_network_security_rule" "add-sg-rule" {
#   name                        = "allow-http"
#   priority                    = 120
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = data.azurerm_resource_group.example.name
#   network_security_group_name = azurerm_network_security_group.main.name
# }




resource "azurerm_virtual_network" "network" {
  name                = "example-network"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.main.id
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

