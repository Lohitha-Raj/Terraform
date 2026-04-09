terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"
    storage_account_name = "tfbackendstorage1234"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}