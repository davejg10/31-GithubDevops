variable "environment" {
  type = string
  default = "dev"
}

variable "rg_name" {
  type = string
  default = "31-devops-github"
}

variable "location" {
    type = string
    default = "UK South"
}

resource "azurerm_resource_group" "landing_zone" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "githubdevopsacrwth"

  resource_group_name = azurerm_resource_group.landing_zone.name
  location            = azurerm_resource_group.landing_zone.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_application_insights" "web_insights" {
  name                = "githubdevops-insightswth"

  location            = azurerm_resource_group.landing_zone.location
  resource_group_name = azurerm_resource_group.landing_zone.name
  application_type    = "web"
}

resource "azurerm_service_plan" "asp" {
  name                = "githubdevops-aspwth"

  resource_group_name = azurerm_resource_group.landing_zone.name
  location            = azurerm_resource_group.landing_zone.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "githubdevops-appwth-${var.environment}"

  resource_group_name = azurerm_resource_group.landing_zone.name
  location            = azurerm_resource_group.landing_zone.location
  service_plan_id     = azurerm_service_plan.asp.id

  app_settings ={
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.web_insights.instrumentation_key
  }

  site_config {

    application_stack {
      # docker_registry_url = azurerm_container_registry.acr.login_server
      # docker_registry_username = azurerm_container_registry.acr.admin_username
      # docker_registry_password = azurerm_container_registry.acr.admin_password
      dotnet_version = "6.0"
    }
  }
}

//terraform init -input=false -backend-config="resource_group_name=backend" -backend-config="storage_account_name=stwhatthehackbackend" -backend-config="container_name=terraform" 
