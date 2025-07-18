# data "azurerm_key_vault" "roboshop3" {
#   name                = "roboshop3"
#   resource_group_name = data.azurerm_resource_group.example.name
# }


resource "azurerm_key_vault" "newsecret" {
  name                = "roboshop10"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  tenant_id           = azuread_service_principal.sp.application_tenant_id
  sku_name            = "standard"
  enable_rbac_authorization = true
  soft_delete_retention_days = 7
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    virtual_network_subnet_ids = [{ for i in azurerm_virtual_network.main.subnet: i.name => i.id if i.name == "subnet1" }["subnet1"]]
    ip_rules = ["3.89.145.192/32"]
  }
}



resource "azurerm_key_vault_secret" "secret" {
  for_each     = local.all
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.newsecret.id
}

variable "keys" {
  default = ["sample1","sample2","sample3"]
  type = list(string)
}

variable "values" {
  default = ["sample11","sample21","sample33"]
  type = list(string)
}

locals {
  all = zipmap(var.keys,var.values )
}



