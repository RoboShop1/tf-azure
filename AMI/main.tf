
module "vnet" {
  source = "./modules/net"
}


locals {
  subnets = { for v in lookup(lookup(module.vnet,"network",null),"subnet",null): v.name => v.id }
}

output "subnets" {
  value = { for v in lookup(lookup(module.vnet,"network",null),"subnet",null): v.name => v.id }
}


# module "public_vm" {
#   source    = "./modules/vm"
#   location  = "public"
#   instance  = "public"
#   subnet_id = lookup(local.subnets,"public",null)
# }


# module "private_vms" {
#   for_each = toset(["app","db"])
#   source    = "./modules/vm"
#   instance  = each.key
#   subnet_id = lookup(local.subnets,each.key,null)
# }
