
module "vnet" {
  source = "./"
}






# resource "azurerm_image" "example" {
#   name                      = "exampleimage"
#   location                  = data.azurerm_virtual_machine.example.location
#   resource_group_name       = data.azurerm_virtual_machine.example.name
#   source_virtual_machine_id = data.azurerm_virtual_machine.example.id
# }