terraform {
  required_version = ">= 1.3.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.4.0"
    }
    
  }
}

provider "azurerm" {
  subscription_id = "fd1f9c42-234f-4f5a-b49c-04bcfb79351d"
  resource_provider_registrations = "core"

  resource_providers_to_register = [
    # "Microsoft.ContainerService",
    # "Microsoft.KeyVault",
  ]

  features {}
}