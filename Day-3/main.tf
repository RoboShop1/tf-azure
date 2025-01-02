module "vnet" {
  source = "./modules/vnet"
}

output "vnet" {
  value = module.vnet.virtual_network.subnet.*.id[0]
}

# module "vm" {
#
#   depends_on = [module.vnet]
#
#   for_each                = var.vms
#
#   source                  = "./modules/vm"
#   resource_group_location = module.vnet.resource_group.location
#   component               = each.key
#   resource_group_name     = module.vnet.resource_group.name
#   subnet_id               = module.vnet.virtual_network.subnet.*.id[0]
#   sg_ports                = each.key["sg_ports"]
#
#
# }
#
#
# variable "vms" {
#   default = {
#     web = {
#       sg_ports = [22,80]
#     }
#
#     app = {
#       sg_ports = [22,8080]
#     }
#
#     db = {
#       sg_ports = [22,3306]
#     }
#
#   }
# }



