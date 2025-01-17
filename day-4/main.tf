
data "azurerm_resource_group" "main" {
  name = "iteration-1"
}

output "location" {
  value = data.azurerm_resource_group.main.location
}

output "name" {
  value = data.azurerm_resource_group.main.name
}


resource "azurerm_kubernetes_cluster" "main" {
  name                = "example-aks1"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}


resource "null_resource" "get-kubeconifg" {
  depends_on = [azurerm_kubernetes_cluster.main]

  provisioner "local-exec" {
    command = <<EOT
    az aks get-credentials --resource-group ${data.azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}
EOT
  }
}