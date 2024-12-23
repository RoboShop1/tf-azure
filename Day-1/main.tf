
provider "azurerm" {
  features {}

  subscription_id = "12f9be95-f674-4dc3-8c29-d915cc4e1f8e"
}

data "azurerm_resources" "example" {
  resource_group_name = "iteration-1"
}

output "main" {
  value = data.azurerm_resources.example
}