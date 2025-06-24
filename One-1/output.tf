output "subnets" {
  value = azurerm_virtual_network.network.subnet
}

output "subnets1" {
  value = { for i in azurerm_virtual_network.network.subnet: i.name => i.id if i.name == "subnet1" }
}