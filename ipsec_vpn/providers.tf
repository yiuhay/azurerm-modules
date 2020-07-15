provider "azurerm" {
  version = "=2.16.0"

  features {}
}

provider "azurerm" {
  version = "=2.16.0"
  
  alias           = "keyvaultProvider"
  subscription_id = var.subscription_secret_id

  features {}
}