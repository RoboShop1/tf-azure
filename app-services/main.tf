data "azurerm_resource_group" "example" {
  name = "iteration-1"
}

resource "azurerm_app_service_plan" "example" {
  name                = "api-appserviceplan-basic"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B2"
  }
}

resource "azurerm_linux_web_app" "nginx" {
  name                = "rfrontend"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location

  service_plan_id     = azurerm_app_service_plan.example.id
  public_network_access_enabled = true

  app_settings = {
    catalogue = "localhost"
    user      = "localhost"
    cart      = "localhost"
    shipping  = "localhost"
    payment   = "localhost"
  }

  site_config {
    application_stack {
      docker_image_name = "chaitu1812/frontend-rhel9"
      docker_registry_url = "https://index.docker.io"
    }

  }

}

###




resource "azurerm_linux_web_app" "catalogue" {
  name                = "rcatalogue"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location

  service_plan_id     = azurerm_app_service_plan.example.id
  public_network_access_enabled = true

  app_settings = {
    MONGO = "true"
    MONGO_URL =  "mongodb://3.82.198.41:27017/catalogue"
    WEBSITES_PORT = "8080"
  }

  site_config {
    application_stack {
      docker_image_name = "chaitu1812/catalogue-rhel9"
      docker_registry_url = "https://index.docker.io"
    }

  }

}
