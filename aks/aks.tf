resource "azurerm_kubernetes_cluster" "example" {
  name                = "dev-eks"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  dns_prefix          = "dev-eks"

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.100.0.0/24"
    dns_service_ip = "10.100.0.10"

  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = lookup(local.subnets, "eks",null )
  }

  identity {
    type = "SystemAssigned"
  }


  oidc_issuer_enabled = true
  workload_identity_enabled = true
  tags = {
    Environment = "Production"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "example" {
  name                  = "one"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id = lookup(local.subnets, "eks",null )

  tags = {
    Environment = "Production"
  }
}




output "odic_url" {
  value = azurerm_kubernetes_cluster.example.oidc_issuer_url
}
