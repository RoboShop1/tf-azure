
provider "azurerm" {
  features {}

  subscription_id = "12f9be95-f674-4dc3-8c29-d915cc4e1f8e"
}

data "azurerm_resource_group" "iteration-1" {
  name = "iteration-1"
}

output "resource_group" {
  value = data.azurerm_resource_group.iteration-1
}