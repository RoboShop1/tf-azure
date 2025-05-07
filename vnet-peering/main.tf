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


module "server-dev1" {
  depends_on = [module.dev-net]
  source = "./modules/servers"
  instance = "dev1"
  subnet_id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Network/virtualNetworks/dev-network/subnets/subnet1"
}

output "dev1" {
  value = module.server-dev1
}

module "server-dev2" {
  depends_on = [module.dev-net]
  source = "./modules/servers"
  instance = "dev2"
  subnet_id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Network/virtualNetworks/dev-network/subnets/subnet1"
}

output "dev2" {
  value = module.server-dev1
}




# module "prod-net" {
#   source = "./modules/vnet"
#   network = "prod-network"
#   net_range = "10.2.0.0/16"
#   subnet1_range = "10.2.1.0/24"
#   subnet2_range = "10.2.2.0/24"
# }
#
# output "prod-vnet" {
#   value = module.prod-net
# }


#
# module "server-prod" {
#   source = "./modules/servers"
#   instance = "prod"
#   subnet_id = "/subscriptions/12f9be95-f674-4dc3-8c29-d915cc4e1f8e/resourceGroups/iteration-1/providers/Microsoft.Network/virtualNetworks/prod-network/subnets/subnet2"
# }
#
# output "dev_ip" {
#   value = module.server-dev
# }
#
# output "prod_ip" {
#   value = module.server-prod
# }
#
#
#
# module "vnet-peering" {
#   source = "./modules/v-peering"
# }