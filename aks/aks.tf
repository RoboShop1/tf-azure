# resource "azurerm_kubernetes_cluster" "example" {
#   name                = "example-aks1"
#   location            = data.azurerm_resource_group.example.location
#   resource_group_name = data.azurerm_resource_group.example.name
#
#   network_profile {
#     network_plugin = "azure"
#     network_policy = "azure"
#
#   }
#
#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_D2_v2"
#     vnet_subnet_id = ""
#   }
#
#   identity {
#     type = "SystemAssigned"
#   }
#
#   tags = {
#     Environment = "Production"
#   }
# }

