module "vnet" {
  source = "./modules/vnet"
}

output "r_output" {
  value = module.vnet
}