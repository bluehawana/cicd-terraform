terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.33.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "1685b800-9e89-46c7-bdf5-053e3bc669b6"
  tenant_id       = "5b679921-53f7-4642-a251-8a603608d21c"
  client_id       = "6d39b61a-8745-4c9b-921b-ac1efdeddefb"
  client_secret   = "Eia8Q~LTQmLMdj2zXN2I1q1yelkrzzLMs5vDsa-8"

  features {}
}
