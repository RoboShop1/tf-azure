data "azurerm_resource_group" "example" {
  name = "iteration-1"
}

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "B2"
}

resource "azurerm_linux_web_app" "example" {
  name                = "nginx1"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location

  service_plan_id     = azurerm_service_plan.example.id
  public_network_access_enabled = true

  app_settings = {
    backend_ip = "localhost"
  }

  site_config {
    application_stack {
      docker_image_name = "chaitu1812/expense-frontend"
      docker_registry_url = "https://index.docker.io"
    }

  }

}