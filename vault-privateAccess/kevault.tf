data "azurerm_key_vault" "roboshop3" {
  name                = "roboshop3"
  resource_group_name = data.azurerm_resource_group.example.name
}

resource "azurerm_key_vault_secret" "secret" {
  for_each     = local.all
  name         = each.key
  value        = each.value
  key_vault_id = data.azurerm_key_vault.roboshop3.id
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



