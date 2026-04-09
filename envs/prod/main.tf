provider "azurerm" {
  features {}
}

module "network" {
  source = "../../modules/network"

  rg_name       = "prod-rg"
  location      = "East US"
  vnet_name     = "prod-vnet"
  address_space = ["10.1.0.0/16"]

  subnets = {
    subnet1 = ["10.1.1.0/24"]
    subnet2 = ["10.1.2.0/24"]
  }
}