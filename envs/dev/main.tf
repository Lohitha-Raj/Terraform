provider "azurerm" {
  features {}
}

# 🔐 PASSWORD VARIABLE
variable "admin_password" {}

# 🌐 NETWORK
module "network" {
  source = "../../modules/network"

  rg_name       = "dev-rg"
  location      = "East US"
  vnet_name     = "dev-vnet"
  address_space = ["10.0.0.0/16"]

  subnets = {
    app = ["10.0.1.0/24"]
  }

  nsg_id = module.security.nsg_id
}

# 🔐 SECURITY
module "security" {
  source = "../../modules/security"

  rg_name  = "dev-rg"
  location = "East US"
  nsg_name = "dev-nsg"
}

# 💻 COMPUTE
module "compute" {
  source = "../../modules/compute"

  rg_name   = "dev-rg"
  location  = "East US"

  vm_names = ["vm1", "vm2"]

  subnet_id      = module.network.subnet_ids["app"]
  admin_password = var.admin_password
}

# ⚖️ LOAD BALANCER
module "lb" {
  source = "../../modules/loadbalancer"

  rg_name  = "dev-rg"
  location = "East US"
  lb_name  = "dev-lb"

  backend_nics = module.compute.nic_map
}