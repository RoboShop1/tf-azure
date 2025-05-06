provider "azurerm" {
  features {}

  subscription_id = "12f9be95-f674-4dc3-8c29-d915cc4e1f8e"
}


module "dev-net" {
  source = "./modules/vnet"
  network = "dev-network"
  net_range = "10.1.0.0/16"
  subnet1_range = "10.1.1.0/24"
  subnet2_range = "10.1.2.0/24"
}


module "prod-net" {
  source = "./modules/vnet"
  network = "prod-network"
  net_range = "10.2.0.0/16"
  subnet1_range = "10.2.1.0/24"
  subnet2_range = "10.2.2.0/24"
}


