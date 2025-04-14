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
    catalogue = "rcatalogue.azurewebsites.net"
    user      = "ruser.azurewebsites.net"
    cart      = "rcart.azurewebsites.net"
    shipping  = "localhost"
    payment   = "localhost"
  }

  site_config {
    application_stack {
      docker_image_name = "chaitu1812/rsample"
      docker_registry_url = "https://index.docker.io"
    }

  }

}


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



resource "azurerm_linux_web_app" "user" {
name                = "ruser"
resource_group_name = data.azurerm_resource_group.example.name
location            = data.azurerm_resource_group.example.location

service_plan_id     = azurerm_app_service_plan.example.id
public_network_access_enabled = true

app_settings = {
  REDIS_URL: "redis://3.82.198.41:6379"
  MONGO_URL: "mongodb://3.82.198.41:27017/users"
  WEBSITES_PORT = "8080"
}

site_config {
application_stack {
docker_image_name = "chaitu1812/user-rhel9"
docker_registry_url = "https://index.docker.io"
}

}
}

resource "azurerm_linux_web_app" "cart" {
  name                = "rcart"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location

  service_plan_id     = azurerm_app_service_plan.example.id
  public_network_access_enabled = true

  app_settings = {
    WEBSITES_PORT = "8080"
    REDIS_HOST = "3.82.198.41"
    CATALOGUE_HOST =  "rcatalogue.azurewebsites.net"
    CATALOGUE_PORT = "80"
  }

  site_config {
    application_stack {
      docker_image_name = "chaitu1812/cart-rhel9"
      docker_registry_url = "https://index.docker.io"
    }

  }
}
