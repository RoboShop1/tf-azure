resource "azurerm_virtual_network" "v_net" {
  name                = "example-network"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "public"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "eks"
    address_prefixes = ["10.0.2.0/24"]
  }

  subnet {
    name             = "db"
    address_prefixes = ["10.0.3.0/24"]
  }

  tags = {
    environment = "Dev-net"
  }
}


# output "all" {
#   value = { for i in azurerm_virtual_network.v_net.subnet: i["name"] => i["id"] }
# }


locals {
  subnets = { for i in azurerm_virtual_network.v_net.subnet: i["name"] => i["id"] }
}


# output "all" {
#   value = { for i in azurerm_virtual_network.v_net.subnet: i["name"] => i["id"]  }
# }
#
# output "public" {
#   value = lookup({for i in azurerm_virtual_network.v_net.subnet: i["name"] => i["id"] }, "public", null)
# }
